from os.path import join
from ament_index_python.packages import get_package_share_directory
from launch import LaunchDescription
from launch_ros.actions import Node


def generate_launch_description() -> LaunchDescription:
    """Launch Fixposition driver."""

    fixposition_driver = Node(
        name="fixposition_driver",
        package="fixposition_driver_ros2",
        executable="fixposition_driver_ros2_exec",
        output={"both": {"screen", "log", "own_log"}},
        emulate_tty=True,
        parameters=[
            join(get_package_share_directory("fixposition_bringup"), "params", "fixposition.yaml")
            ],
        respawn=True,
        respawn_delay=5.0,
    )

    return LaunchDescription([fixposition_driver])
