From: Alex Xu <alex_y_xu@yahoo.ca>
Subject: getrandom waits for a long time when /dev/random is insufficiently
 read from
Date: Thu, 28 Jul 2016 18:07:32 -0400
Message-ID: <20160728180732.12d38880@alex-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org,
	virtualization@lists.linux-foundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nm1-vm1.bullet.mail.bf1.yahoo.com ([98.139.213.163]:41821 "EHLO
	nm1-vm1.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751961AbcG1WOU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Jul 2016 18:14:20 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Linux 4.6, also tried 4.7, qemu 2.6, using this C program:

#include <fcntl.h>
#include <stdlib.h>
#include <syscall.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
    char buf[16];
    int fd;

    if (argc != 2)
        return 1;

    for (int i = 0; i < atoi(argv[1]); i++) {
        sleep(1);

        if ((fd = open("/dev/random", O_RDONLY)) == -1)
            return 2;

        if (read(fd, buf, sizeof(buf)) < 1)
            return 3;

        if (close(fd) == -1)
            return 4;
    }

    sleep(2);

    if (syscall(SYS_getrandom, buf, sizeof(buf), 0) == -1)
        return 5;

    return 0;
}

$ qemu-system-x86_64 -nodefaults -machine q35,accel=kvm -nographic -object rng-random,id=rng0,filename=/dev/urandom -device virtio-rng-pci,rng=rng0 -kernel linux-4.7/arch/x86/boot/bzImage -fsdev local,path="$PWD/root",security_model=none,id=root -device virtio-9p-pci,fsdev=root,mount_tag=/dev/root -device virtio-serial -chardev stdio,id=stdio -device virtconsole,chardev=stdio -monitor none -append "root=/dev/root rw rootfstype=9p rootflags=trans=virtio console=hvc0 init=/strace /test 2"
execve("/test", ["/test", "2"], [/* 2 vars */]) = 0
arch_prctl(ARCH_SET_FS, 0x601098)       = 0
set_tid_address(0x6010d0)               = 29
nanosleep({1, 0}, 0x7ffcdb7ea6b0)       = 0
open("/dev/random", O_RDONLY)           = 3
read(3, "P'\333\362\352\247\212\272\357E?\343", 16) = 12
close(3)                                = 0
nanosleep({1, 0}, 0x7ffcdb7ea6b0)       = 0
open("/dev/random", O_RDONLY)           = 3
read(3, ">>9\252]\332T\322dL\203\231C\255\303\376", 16) = 16
close(3)                                = 0
nanosleep({2, 0}, 0x7ffcdb7ea6e0)       = 0
getrandom(<some time later>[   89.166661] random: nonblocking pool is initialized
"\217\0\206\220\36t\3\353\t\227\377\356\315\320\2452", 16, 0) = 16
exit_group(0)                           = ?
+++ exited with 0 +++

Identical command but replaced 2 iterations with 3:

$ qemu-system-x86_64 -nodefaults -machine q35,accel=kvm -nographic -object rng-random,id=rng0,filename=/dev/urandom -device virtio-rng-pci,rng=rng0 -kernel linux-4.7/arch/x86/boot/bzImage -fsdev local,path="$PWD/root",security_model=none,id=root -device virtio-9p-pci,fsdev=root,mount_tag=/dev/root -device virtio-serial -chardev stdio,id=stdio -device virtconsole,chardev=stdio -monitor none -append "root=/dev/root rw rootfstype=9p rootflags=trans=virtio console=hvc0 init=/strace /test 3"
execve("/test", ["/test", "3"], [/* 2 vars */]) = 0
arch_prctl(ARCH_SET_FS, 0x601098)       = 0
set_tid_address(0x6010d0)               = 29
nanosleep({1, 0}, 0x7ffc9e13fb70)       = 0
open("/dev/random", O_RDONLY)           = 3
read(3, ">\202\264\350\226\364\364\320'-\200\16", 16) = 12
close(3)                                = 0
nanosleep({1, 0}, 0x7ffc9e13fb70)       = 0
open("/dev/random", O_RDONLY)           = 3
read(3, "\377:\2076\213q0E\307\377\\\234\217\"g\254", 16) = 16
close(3)                                = 0
nanosleep({1, 0}, 0x7ffc9e13fb70)       = 0
open("/dev/random", O_RDONLY)           = 3
read(3, [    3.312266] random: nonblocking pool is initialized
"O\2112g\375\25]\270\347\v\34XP", 16) = 13
close(3)                                = 0
nanosleep({2, 0}, 0x7ffc9e13fba0)       = 0
getrandom("\215\317\207/\324\6\300\216\332zN\351a\323\231\36", 16, 0) = 16
exit_group(0)                           = ?
+++ exited with 0 +++

(irrelevant kernel messages have been removed for clarity)

Removing the calls to "sleep" produces similar results except without
sleeping or the corresponding strace output. Running both commands
repeatedly also produces similar results; the timing of the getrandom
return and "random: nonblocking pool is initialized" message
is different for each run, but it always takes 90-100 seconds.

Sorry if these aren't the right lists or if this is a known issue.

Please CC me on replies.
