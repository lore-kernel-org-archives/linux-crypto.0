From: kernel test robot <fengguang.wu@intel.com>
Subject: [padata] bbd8797975:  WARNING: CPU: 0 PID: 1 at kernel/cpu.c:258
 put_online_cpus
Date: Sat, 22 Apr 2017 07:04:06 +0800
Message-ID: <58fa8fe6.FNRDcPla1desvwKQ%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_58fa8fe6.KGFv/UXliio9jXxjVQFvebtQ9aGO5BcnYb6+L2i99TruwxkY"
Cc: LKP <lkp@01.org>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        wfg@linux.intel.com
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:7605 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932253AbdDUXFH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Apr 2017 19:05:07 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a multi-part message in MIME format.

--=_58fa8fe6.KGFv/UXliio9jXxjVQFvebtQ9aGO5BcnYb6+L2i99TruwxkY
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git smp/hotplug

commit bbd8797975ce0191ac72d575f7e34033b5a5f620
Author:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
AuthorDate: Tue Apr 18 19:04:46 2017 +0200
Commit:     Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu Apr 20 13:08:51 2017 +0200

    padata: Avoid nested calls to get_online_cpus() in pcrypt_init_padata()
    
    pcrypt_init_padata()
       get_online_cpus()
       padata_alloc_possible()
         padata_alloc()
           get_online_cpus()
    
    The nested call to get_online_cpus() works with the current implementation,
    but prevents the conversion to a percpu rwsem.
    
    The other caller of padata_alloc_possible() is pcrypt_init_padata() which
    calls from a get_online_cpus() protected region as well.
    
    Remove the get_online_cpus() call in padata_alloc() and document the
    calling convention.
    
    Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Cc: Steffen Klassert <steffen.klassert@secunet.com>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Steven Rostedt <rostedt@goodmis.org>
    Cc: linux-crypto@vger.kernel.org
    Link: http://lkml.kernel.org/r/20170418170552.697398655@linutronix.de

a792e10c4c  padata: Make padata_alloc() static
bbd8797975  padata: Avoid nested calls to get_online_cpus() in pcrypt_init_padata()
d215aab82d  cpu/hotplug: Convert hotplug locking to percpu rwsem
9c2e936e65  Merge branch 'WIP.x86/fpu'
+-----------------------------------------------------+------------+------------+------------+------------+
|                                                     | a792e10c4c | bbd8797975 | d215aab82d | 9c2e936e65 |
+-----------------------------------------------------+------------+------------+------------+------------+
| boot_successes                                      | 33         | 0          | 0          | 0          |
| boot_failures                                       | 0          | 11         | 12         | 11         |
| WARNING:at_kernel/cpu.c:#put_online_cpus            | 0          | 11         |            |            |
| WARNING:at_kernel/locking/lockdep.c:#__lock_release | 0          | 11         | 12         | 11         |
+-----------------------------------------------------+------------+------------+------------+------------+

[   65.067325] OCFS2 User DLM kernel interface loaded
[   65.072268] gfs2: GFS2 installed
[   65.076252] FS-Cache: Netfs 'ceph' registered for caching
[   65.078480] ceph: loaded (mds proto 32)
[   65.083736] ------------[ cut here ]------------
[   65.086552] WARNING: CPU: 0 PID: 1 at kernel/cpu.c:258 put_online_cpus+0x3d/0x8d
[   65.090328] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.11.0-rc6-00220-gbbd8797 #1
[   65.093572] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.3-20161025_171302-gandalf 04/01/2014
[   65.097477] Call Trace:
[   65.098821]  dump_stack+0xc4/0x122
[   65.100557]  __warn+0xd2/0xf0
[   65.102175]  warn_slowpath_null+0x18/0x1a
[   65.103888]  put_online_cpus+0x3d/0x8d
[   65.105651]  ? kobject_uevent+0xb/0xd
[   65.107458]  pcrypt_init_padata+0x133/0x145
[   65.109255]  ? crypto_ccm_module_init+0x7d/0x7d
[   65.111265]  pcrypt_init+0x44/0xab
[   65.112726]  ? crypto_ccm_module_init+0x7d/0x7d
[   65.114576]  do_one_initcall+0x88/0x15f
[   65.116409]  do_basic_setup+0xa2/0xc0
[   65.118074]  ? kernel_init_freeable+0x107/0x107
[   65.119931]  kernel_init_freeable+0x92/0x107
[   65.121808]  ? rest_init+0x138/0x138
[   65.123539]  kernel_init+0x9/0xee
[   65.125096]  ret_from_fork+0x31/0x40
[   65.126904] ---[ end trace f7501a7dd73074ba ]---
[   65.129352] ------------[ cut here ]------------
[   65.129352] ------------[ cut here ]------------
[   65.131365] WARNING: CPU: 0 PID: 1 at kernel/locking/lockdep.c:3523 __lock_release+0x7d/0x395
[   65.135060] DEBUG_LOCKS_WARN_ON(depth <= 0)
[   65.135064] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W       4.11.0-rc6-00220-gbbd8797 #1
[   65.140384] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.3-20161025_171302-gandalf 04/01/2014
[   65.144075] Call Trace:
[   65.145479]  dump_stack+0xc4/0x122
[   65.147296]  ? vprintk_func+0x43/0x45
[   65.148828]  __warn+0xd2/0xf0
[   65.150502]  ? put_online_cpus+0x73/0x8d
[   65.152274]  warn_slowpath_fmt+0x44/0x46
[   65.181795]  ? put_online_cpus+0x3d/0x8d
[   65.182749]  __lock_release+0x7d/0x395
[   65.183722]  ? printk+0x3c/0x3e
[   65.184575]  lock_release+0x4a/0x75
[   65.185511]  ? put_online_cpus+0x73/0x8d
[   65.186512]  put_online_cpus+0x8b/0x8d
[   65.187483]  ? kobject_uevent+0xb/0xd
[   65.191258]  pcrypt_init_padata+0x133/0x145
[   65.192893]  ? crypto_ccm_module_init+0x7d/0x7d
[   65.194775]  pcrypt_init+0x44/0xab
[   65.196439]  ? crypto_ccm_module_init+0x7d/0x7d
[   65.198318]  do_one_initcall+0x88/0x15f
[   65.200114]  do_basic_setup+0xa2/0xc0
[   65.201772]  ? kernel_init_freeable+0x107/0x107
[   65.203655]  kernel_init_freeable+0x92/0x107
[   65.205496]  ? rest_init+0x138/0x138
[   65.207383]  kernel_init+0x9/0xee
[   65.208853]  ret_from_fork+0x31/0x40
[   65.210663] ---[ end trace f7501a7dd73074bb ]---
[   65.212730] ------------[ cut here ]------------
[   65.212730] ------------[ cut here ]------------
[   65.214670] WARNING: CPU: 0 PID: 1 at kernel/cpu.c:258 put_online_cpus+0x3d/0x8d
[   65.218368] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W       4.11.0-rc6-00220-gbbd8797 #1
[   65.221974] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.3-20161025_171302-gandalf 04/01/2014
[   65.225929] Call Trace:
[   65.227435]  dump_stack+0xc4/0x122
[   65.228926]  __warn+0xd2/0xf0
[   65.230648]  warn_slowpath_null+0x18/0x1a
[   65.232426]  put_online_cpus+0x3d/0x8d
[   65.234177]  ? kobject_uevent+0xb/0xd
[   65.235861]  pcrypt_init_padata+0x133/0x145
[   65.237688]  ? crypto_ccm_module_init+0x7d/0x7d
[   65.239575]  pcrypt_init+0x5b/0xab
[   65.241313]  ? crypto_ccm_module_init+0x7d/0x7d
[   65.243080]  do_one_initcall+0x88/0x15f
[   65.244777]  do_basic_setup+0xa2/0xc0
[   65.246595]  ? kernel_init_freeable+0x107/0x107
[   65.248488]  kernel_init_freeable+0x92/0x107
[   65.250420]  ? rest_init+0x138/0x138
[   65.252090]  kernel_init+0x9/0xee
[   65.253695]  ret_from_fork+0x31/0x40
[   65.255430] ---[ end trace f7501a7dd73074bc ]---
[   65.260862] NET: Registered protocol family 38

                                                          # HH:MM RESULT GOOD BAD GOOD_BUT_DIRTY DIRTY_NOT_BAD
git bisect start 55c50180fc1ef6a9cf0f2fb07bdf7715b232c4c0 4f7d029b9bf009fbee76bb10c0c4351a1870d2f3 --
git bisect  bad 2fb75380f460ee405369eff321c0033f387e38f7  # 12:49  B      0     2   12   0  Merge 'pci/next' into devel-spot-201704210849
git bisect good 76511bda484929968e54a4b54164efa34c642b51  # 13:23  G     11     0    0   0  Merge 'rcu/rcu/next' into devel-spot-201704210849
git bisect  bad 8d7a6f8112f795e40015fe86c409cc00bcd11b46  # 13:41  B      0     1   11   0  Merge 'tip/master' into devel-spot-201704210849
git bisect good 6a1914a735e48a5eccb285b496aeb7072a3d52ed  # 14:16  G     10     0    0   0  Merge 'saeed/net-rc' into devel-spot-201704210849
git bisect good 5dc83be3c96856d3199184818bcf280a47eb42eb  # 03:11  G     11     0    0   0  Merge 'tip/timers/core' into devel-spot-201704210849
git bisect  bad 274e37a664e9ed44e7237068bdc177328f75540c  # 03:22  B      0     2   12   0  Merge 'tip/smp/hotplug' into devel-spot-201704210849
git bisect  bad 9ef0b62e7059e3ea85e2e5c4894bc2cb78b04eed  # 03:45  B      0     5   15   0  x86/mtrr: Remove get_online_cpus() from mtrr_save_state()
git bisect good e878ce0f69caa5c37f3183af711291c0c6a38d6a  # 04:06  G     11     0    0   0  stop_machine: Provide stop_machine_cpuslocked()
git bisect  bad bbd8797975ce0191ac72d575f7e34033b5a5f620  # 04:22  B      0     4   14   0  padata: Avoid nested calls to get_online_cpus() in pcrypt_init_padata()
git bisect good a792e10c4cb42b8508364c7e187caac2409e6166  # 05:01  G     10     0    0   0  padata: Make padata_alloc() static
# first bad commit: [bbd8797975ce0191ac72d575f7e34033b5a5f620] padata: Avoid nested calls to get_online_cpus() in pcrypt_init_padata()
git bisect good a792e10c4cb42b8508364c7e187caac2409e6166  # 05:30  G     30     0    0   0  padata: Make padata_alloc() static
# extra tests with CONFIG_DEBUG_INFO_REDUCED
git bisect  bad bbd8797975ce0191ac72d575f7e34033b5a5f620  # 05:50  B      0     4   14   0  padata: Avoid nested calls to get_online_cpus() in pcrypt_init_padata()
# extra tests on HEAD of linux-devel/devel-spot-201704210849
git bisect  bad 55c50180fc1ef6a9cf0f2fb07bdf7715b232c4c0  # 05:56  B      0    15   28   0  0day head guard for 'devel-spot-201704210849'
# extra tests on tree/branch tip/smp/hotplug
git bisect  bad d215aab82d81974f438bfbc80aa437132f3c37c3  # 06:13  B      0     3   13   0  cpu/hotplug: Convert hotplug locking to percpu rwsem
# extra tests with first bad commit reverted
git bisect good f49e5c863cb890554d92d5389d9ff7dc3c96035b  # 06:40  G     11     0   11  11  Revert "padata: Avoid nested calls to get_online_cpus() in pcrypt_init_padata()"
# extra tests on tree/branch tip/master
git bisect  bad 9c2e936e655a62ba3ccd0fa640b121f2db036207  # 06:58  B      0     1   11   0  Merge branch 'WIP.x86/fpu'

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/lkp                          Intel Corporation

--=_58fa8fe6.KGFv/UXliio9jXxjVQFvebtQ9aGO5BcnYb6+L2i99TruwxkY
Content-Type: application/gzip
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dmesg-yocto-vp-6:20170422042348:x86_64-randconfig-a0-04211049:4.11.0-rc6-00220-gbbd8797:1.gz"

H4sICNmP+lgAA2RtZXNnLXlvY3RvLXZwLTY6MjAxNzA0MjIwNDIzNDg6eDg2XzY0LXJhbmRj
b25maWctYTAtMDQyMTEwNDk6NC4xMS4wLXJjNi0wMDIyMC1nYmJkODc5NzoxAOxd62/jSI7/
fP1X8LAfJtmNHZXeMuDBJo7TbSROPHF6pm8bDUOWSo4msqTRI50M9o8/svSwbNl59ORwuIMN
dKwH+StWFVlFsugZbifBEzhRmEYBBz+ElGd5jA9c/oFvvuOPWWI72eyeJyEPPvhhnGcz187s
HkiPUvVRDVWVNa18HfBw7S1jjmzr0ocoz/D1+qviq3zV4pQdWTFd6UPR+iyLMjuYpf6ffL11
S1YI5MMZd6JlnPA09cMFXPph/tjtdmFiJ+LB8PKcbt0o5N0Pp1GU0cPsjkMB3/3wFfAjdQvU
bwUAPHDkjkJQu4x1pU7i6B0UTJY6i/ncNQ3LgIP7ee4H7j+D+7gT8kdJO4SDheM0ONUuUp3x
uW+Xdx3zEA7hbwym4wlM7QxO4gRkGSS1x4yeymAwvQVZYsamTINoubRDFwI/xEFIsBP9Y5c/
HCf2UoK7PFzMMju9n8V26Dt9Bi6f5wuwY7wpLtOnNPljZgff7ad0xkN7HnAXEiePcU55Fy9m
TpzPUhxnHG5/yXFi+jhJEPKs63uhveRpX4I48cPsvosN3y/TRR/7WDTYYZBGXhZEzn0e10KE
S3/23c6cOzda9MVDiKI4LS+DyHZnKL7rp/d9GaFxCrP6gQRuMne7Sz+MkpkT5WHWN6kTGV+6
3SBaoMo88KDPkwT8BdLwGT4Uz0DociFpP8ueptIRY5qMfSnVe+dDCR4Wdh/BlnYAyXca6/v+
cTHJnYynWXqc5GHnj5zn/PgpcrKo8xAfP5r6TFc7Cc4OYnn+omNLHUmVGUMFPQ5IlzouCdYT
fztpHGUdmmKikUzV6pX6ZBmawyVmMdsxZFczNM/giiopylyzNU+Xpd7cT7mTdQpM1TzuPizp
+s/OaxGqdmVJZaaidIxe1Y2ODnPsgnPXb0h8vENiOL2+vp2Nxicfh/3j+H5R9PKFkUDL6KAN
HL9W1uOqc7sNsK0im2aDIh17cd6DaR7HUSIs/8v05NcheNzO8oSL9YT14KdH0wAPdVKQxBFq
DyR84aPCJelPPwYrI+x0OvzLOCrinPz65TU4j2jBGZ9FnoeL+1f5Ww9AM/Sj6jktoWnxWNb0
nSjDcn0ouCpZUhTGOCKDyXB3AMICPwVTkWH+hOZxBLlYbn9CrtC1E/cn8MiWstYCy01UZjgd
XU87aPYPvottxXdPqe+g4d2cjGFpx71NJkFecH5d8mVzIyg/nbVHljf3vG8oE/XlTWCW57TB
PALDQeDJA3ffBOe1ZfN+HI5tdpV5nsu8H+kqccotsB+WzeMeDVwTjh79MFyBtgb3onRis+sV
WwLpYr0poDmQdbVUcY47aeX2fBU7BwKTihYmsEl+9QUOho/cydEsznwx3oe0dWW4LuOW3wP0
mfyH1hxMx9RPkLsmkJvCw7ZNnI1HPfhlOP4M09J8YDKAA19VpfMv8A+YjEZfjoBZln54JEYN
WNfqKrQu60yStRkzmCLJnQUxBx56FMcSO8a36mZLn55iHDs/jRIcLhKcuz24+HW83UoLD2Fz
cqpJaegd9Ps/75yXAivhy+ihiWWvsMqJ3a7DBXtgp9ks9kLoI7dQXlwoHmd24tzVj9VKwk2I
8e3NDfbXs/MggwyHoAffEz/jnbnt3G8l9vxH8pHscIFLX6kPrVUJr0UfrHP8PIMIcCLoTgVd
Hjq2c7etpwADQXfewCv1a6uQD3bii9F/WU6Y2yluKJJZjhAOXnoP5+f1/XNSoUtZqHtranEr
eead8sw79Zl32jPv9GfeGTvf0e42ObntoStNvkme2GSx8FXqGLgf/nYK8NsA4POgg/9g7f63
W4CWRTvo0uP2Jhx5jJd22IeCOv161sbGU2w4r2dtbDLeVlYPHSRX8I0nnUyoDIYfDQB9rlcA
eImmiJtwjAZAVIRoFnoi6FroAMvY6QG+NKSOpztGyxM7JeXD1qLkCTC0XMYRhTKb6JYpiMVX
4WHIpm7ILbCbC5w4jLhMj+ODIyivxRIy+Xh7cno5fIbHa/B4r+KxxIOCxyqXvZd5WIOHPceD
Ps/ZaHpR74HMcxy9mFDkc7ZO6MlggjvGUATuxXw6d9y5T/MlBaC+h86UUPBd9lDw30zPJuvu
yrmOoy9WNabCwQPOw+n14NMUDncC3DZ9ivPzITPPBgJAkQiAlQBw+mUyKMhLWvGkvtvRwDl+
bTZgnJqCzVBbDRTkb2ngrN0D9LlpCJhhmK0Gzn6kB9NWA1Ixxmproyp4TiajQWtY5aKpLUIV
5G8R6tNk2J63E7WYt3YDBflbGriMyJsXgtmuS8kZbM7jXBBtspRrjaDOIvDqjyacQDiA8lMB
tBq9f1h2HEpA9OCzCEOWaZKCOtd01UWJKXdS3rQab7A6cQ5ossgLUk941tjBI8p7LG1cuOi1
oHwGogiCUjRGF4o4DL9A1QzZZJZkgfPkBDzdBBDMaZQnDjomDTTaoynp5W18hOdTQNFr5riq
zFXX8+ZH4pXvBnwW4jvTZLj6aBZTTQXCVrv/isLKd9jiM5yNT4ph3xJx0eK2FtV42zcegYIx
4haUMgu4LZhpo1wVeRkAvoyzp5YzFD2INfBP6g8GoEkm9kmODg2ElOHcoC/WzXI/IoJyENrt
ipf4aGvY2RoEyeLbxX8GZndItwkzCv2MuIvMrYCUXiHWTrzrsAIRKdbYJjUAjCMsubWBF9pA
49sDXQVBi8qOWk4DjTKgDT/HI8slz64YoUmsWJZZkB/B5ej8Gn3XzLnrtUy3Uq6Ci1nmWwRb
8cm6hXtVuz2FbV/bJuPOrb/kCYyuYRIlIretS60h+4GFsGQh6tnVeAQHthP7aM1faQnA+NYL
xD/0nTJ8xL611sHRNfF+ldCnpfQvstKCVqWkmXG0JoSIsPH9x+kIpI6sbBdndHU7m94MZte/
3sDBPE8plsjTmZ/8gVeLIJrbgbiRK/naUoU4RhR1kTDo+tFXlvgL+haA+D26+UV8i5EanUF9
eYU7T8sFfFEyrSmZBnf+4g5ELuBl4VgpnLIhnLZDOO3NwllN4ax3Ec7aIZz1ZuHY2qTi3XuI
Z+8Qz367eGxNPPYu4s13iDffId7NL1KxxsyfIELrSnyXt3I6r9Z6tqP11vLzakRlB2LLwl+N
qO5AbOWX6hHS3nGE9B2tt5LYr0Y0diC2jt5ejWjuQNyxLyCP9fII1bTsFQq3ImbvOPbOjn45
P4zo7kBs+QSvRuQ7EFuO36sRvR2I3iZiEW7Q0MPB+OTs9rDO0DhrmSY/LI5D8PqZkMx3yZkw
JVO3ZYxbKGcn/H/ubvUX0mVMKWwMGIMg+k6CMBhMPqMbg8t2lMVBvhD3OwKuwlvYDLnmEoVc
lXfQWlTX0vVy8ZTcTcq/zEWaw36w/UD44zQUk8EIXP7gO233ujqNj+3EfvCTLLcD/0+UqziZ
Bxy1LYnptVgp4Z4fcrfzu+95PnmvmxHTRqRUPd4Ik5jF0AuUVFWXDY2a2RIrCa97FvPEoUOy
q5sZDuy0h75wmNDpOTU8m/tZunqE+GmP0Q252cXdJmqFN1zOuUsnYapVuqLHFG7+s8qOMU9k
yyVImWVgICtBIoGrMJUyt7JkGUxrOUkxInRs1Ayn9xwbCJI++/srYNCzRNXapMBZKoMSO30K
HZici5kX4fS2WDnNuB1QncFayE1ddI22kp/mfpChYpO3HvhpllLuU0SuUeLyBJmjuR/42RMs
kiiPSaGisAtwS0ENVFGNbJpaaym+KBTN2ZdX7Msr9uUVby2vEGrfK76g0P7qBKrlbkxwI72z
07syWc1D3HXJLnGwTDgQhow3R8B0BaN4UVHQ2nnOiOsJ6JiKbwXTNU3RazR08TRZRbvfATei
VbmzG02RDX0lG7qgsi4zdZdwY5FM6oGqqIYpXRxrsmIw+aKxGR7IisSki2p3o8q7I1AkWb1A
e6DiuiOwDJPuouJOYRYC+KGf4bWCi/cFzFPc203TUvBFlUnBzf4CnKXdqR60ZJtefj5FB+M3
3F4XYV9HX/6aOtWXOhgojP3wev47qj6uQUfCW+hjQHKF0uFFjcQKpJs8DGmBvRl8xhU/8EBY
7ibVJ58ndC5bVHQgqb+MA77EkRX+T3eT/j+IRiylXtohn8elQyKHGvK3qFSTi1ZFl8fF6cdL
DKfFYoMrMNju73makUiUnw247YFnh7gwkzekq9sbwwFG3XCEz0IDBR6uq5UrgONKvKutv89a
KAiCvppomjAWPFpyUmnaLWmbKESYkThimppgm1jYLHqq056q4BaOhBgOpz00Jqa3ZL/2qLbJ
FVOBUxLQEXUpPN6te4iv4CF6dKZavRsUqz1u6lGA/hn8+vHkH2Cik6htUtY1F7QxtMstSqpd
1Rm7zrT2lZt712LvWvy/cC32lZv7ys195ea+cnNfublqaV+5ua/cpM++cnNfubmv3NxXbu4r
N/eVm/vKzX3l5r5yc1+5ua/c3FdubikF2ldu7is395WbTfH2lZv7ys195eaPIu4rN7fN275y
c1+5ua/c3Fdu7ssr9uUV/zfKK/aVm80U1L5yc1+5ua/c/F+p3NyCOt0Ne4kqg9oW89DlofME
D2gWaHBRQofD8RNGA3cZHDiHuDZJOtygMn6y0QJHodOlv4sIxlEQ2skmLv33QccnX2aX14OL
s+FkNv18Org8mU6H0x6A+Rz1DMlvP/Wg/qjPkhP4xfC/pjWDiSv9NgbR/KeT6afZdPSvYRNf
slpastnC8Or2ZjQsGxFr4Uscg08no6tKKrEWbxWKqLYJtbWNKklfxbPBxuRRWNUDUzcY3J+2
mNG7BnLd0ONMcierwDxULOHD4JajV/tDS5uaccZdzLO/HlwYzbCibIaQi7bQHWiUHa7rrax/
gyxFB/ysrNkBSlp3NVTQ8ac/yb/D8CqNGjrJNMtEk0TdnidFWaPLA5sGMIrhIL33KQI8LAqS
MrKBnOPkaIppdOmIL1pE49FkCgdB/Huf2sKmGrEgky2VYWjguzPsa68qrak2TXQb/GW+xNtG
EoupmqlX0e4AvUrs64MvEtPC/2FslayUNdOoaVkRXp+ML4stOoU0d6i/Xh4ET2A7f+R+QrUK
5MLjmtUYOtmwTJXOh9CBeWarZ7gL1zs97n5oUPLmPi9bFs2CgBIVon8RT5EwkP5Gi2kPJlX5
46SaSBid9RrBkyLLFi1ddpoVuU7wby9PVw2qF6cURslj8aXS14pXlQxjjdd9iRf9sI9NCF1W
JZzu84Rz0iTKbmAAh36MTfVuaWlX6CRJFzWPIWkKa6QoxvYjFeSJbsa4mZRx2YpeRqe5XrRh
+JhRwgWVA0fobytRDE3RcEaHVyenl6OrjzC67hTZmZtfVrZlWLJqfROuExLM2gQUUSOKCOIw
oMWgEf+GUUZ7SCgMbEWqGiRX42RligaDkaYwqsIlPZAwSOv8jGuAIr4phcRQVVzek+BEFAXi
xRm6D73GgbklSYrxMrJcIksVsvQysqZa+svISomsVMjKS8is8p1fQFZLZLVCVt8LWSuRtQpZ
K5DZX0bWS2S9QtbfS2ajRDYqZOO9kM0S2ayQzfdCtkpkq0K23mucmVRC27WpSO+GXZnhvMZm
74ZdGaJTY8vvNdqsMkW3xn43W2SVMfIa+92skVXm6NXY2muxm4sv07evvltpjTfQmm+gtV5P
K+/YLbbSsjfQym+gVZ6n7XZvR+PhTQ8e8HWE0T5tIcTP+gKA9WVxK1OGEe/pexPjdjpA3852
RbVmJooeNqKqirLe53G7lnp00IKOhvDyVj7NwSc7/c6D4BAOPHvpB0+icoISuOib9oRpHQE6
vzElcUVhU0tpJjwR5yihw2FIDjP6EHmYFj+goR+S6CRAgYjuCI4QTMafwU1QFZMjkUj9bqNQ
wtlO0b0InrqrNqgURHSlB6f0CwLS9TyGlOMgu1QCJqJ+jGJWLOgIKzVLlFPsiBxMVNYcFccx
K2JVVuVv0Nn4rN5rCrkt/waq/RCZldzPeG/1Xtd11uZfxzAlzaISFyq3zziMyIOG6B7g3ysa
dOcFDYVT6I5to2FUjvtCW4ypOvbnYxS5RyKTQNXgJLdjp+gVxnaKUdt/NkFlU7K2g+5oQZWZ
2VCuIqcfeTiwdcyTFj+7sGn6DzYDmJUCMV03SU+pNG9W1teN7UQkjdLCfz9gZU0a1e0edn5G
NI1pTDHRhe+ocnndgLRMxuhnJw/ZMvZQE8nh9ItDrJpIZpqmFQXoS4yIijwhzEUgW/zvSHBU
xnXsyhRZZcpG+Pk/eLzFFM2g8MDLM/64PUWrrXKqylEZ4a0HM0wxTB0H95GSKHaeRXTQSVmj
p7Igco5KUVcoL+mJl4fiRzPIbz88QvFZ4Vki/osp3R3hqKWcwn8qYicrrDOPpYrVbKoskxg1
Gx2yrNKULWrFYCKIRUkSSsgmfG0K6zdpPi9OR1asui7hoF0Nb3twU0fs4rdAkRMFUCxvjVwc
0zAoQQ4nzmlaqkLRBZ3Ph6JQLcxXtKj0aFeTweAW7nD1xVWXVnpRxL9aejSMr1gVI9PhtTjX
puPWdg6BaYYkYcDjOjZQkth3yjpJSh/X5WGorN3VFoDRuqaQFKOqqHb9RFs0x0TuUvy2xBYx
ecUuK4omo+lumSZVUk0N+5fYvqvj3KZcfmT4ZsHDg0MAjVnoa54e11Caicq1hR61jegVZrI1
ekMzGWlPk15e4ev0m8UmvYWRpyW36Ut8NJsmPsPwytSZtU6vrvDRxNbpUZsVWve/R8m9ON+i
M0acyk4SzX0R35KSFr8ho+F0aFL4Y4xPKINV73f+EuPmrEKlzBWtjZtSlFKjnatrUsiGrBta
TV/onx0sosTP7pYVf9GHVhdkQ9VktWbuUiKvaKhu5wiS5fd174D4dBGJrzWaYlsKjnCC2yrq
3tNKipqNKiBq3T4RB+Oz6+noAF3LHNemM1FPcLgil9VVuqhBvnI9Whyq2N5aHEpXgtl0MKH8
Aw/JLNIGEy6V25hWzZwsFmh8lEzebFGRJL1RpIPuURInPNt0qIhQZqu+H5SuTQpTCaYKTLUG
ovLfvF1tc9s4kv4rrL2tGmfWVkAQb9Su986xk6xvEsdnOTNzlXKpKIqytLZehpSceH/9dTdI
AqIoS5q57HzIWFL3A7ABNLqB7qZC2VpCu0LLiA5ckxNsIl8taqu95gN4ZdYW9ngOi3SQT4b3
WfB1Arrza3nUj9h/DSajAExMeEJQvpjnmwV/WqST09k8zYs/0bFbnmEngwT0kGtHhoLVo4J6
6Qb2cDSssJkv8AWI4wj0dIKnL7grfbEhOCej0Z17SrCJ8KgGI2GD66trdsaiLgMLEyR/3g0+
9YJaQl962T3e6BR3NbMyPDJbmEFJT/Ck6ejsbf/q023/3afPVxev/lpeL1BUT+/6Yw2lGZdt
/UAUvPhJhsPg48fzT1fvLt/70T7HQZrMfliW6hFfioZn10MSyLpCLWB5Z2DNor5fjidFOSId
1wWp8NQVOf0Rg8at4KA7VfgEUmtQjBi+Mel7P9v4BmLIM2tfBF8m86CMIce48XSky1ngBKlj
MCIOAhvaqCA0UppgseCoifYBa0sWHbSD6tBGq+wLuha7NBi1g8Yx7vP7gLq5W3ELFmo8hgPu
mpOxDkZPoX7rhhyP/2w0GgODL6GwbFQTbhRhr4yZaWCEDkOTV9SCEfoY2gi5gRE6jLANA9wh
4zBEDJtCGwboOxJmtxr5lJNM4X+eKBTsmXEb+yOoy/Q5uLx4G+Ax/kMFGDpAFo5o5MORdoAw
ubk+CFA4wGikPKRI6eggJON1Tduuab9rksyVAwBTr2va71os5CZSVA9ciJ7C5uAbfwIZztTm
BAKMsgtVw8ouLxWN0PlIwNenCzfMPBekwx2iiMWm6DcRtUXUrA2xV7k8CKg3ATnNcVgiogt+
ZtjymJG/TiSTMgzbMLzpZNd9GUlH6z4p3SjYit1kleDTq+a69bGMwwLF4ekQNvKWv9TgFTXn
vAcTMR8mczBZS5c0eP5NEUWeKmEsaxERXxORsWbxJsamiLJB6vozHK09Vhxz3pyUPoxbZ2U9
iBTWW80OPoURzeUWbZOKcb0YbEpFSaU3tIqwEycZCZRK28QJfamATUz7+ibGhh5KmbCPo70u
xCF04gV2sTZXQjdXQl+oGoOFmurVg/FCbik+t4QZaDt9lRhMluuy0RJcvuZoy8Nko7UiK3kT
o0U2xspm4HUh5mxDfcmtsuFONtyXjQFHUr8AsyYb42Qz2iobIyMmm3NQHSYb2M5AN7VhtMgm
tbLxH8oIbZr6Sm2VTeRkE/myifGCu7kCVLtsUjdv0u3zBnacOGxKWx8mm1gJETUXhW6XTWhV
ROipiDhWdCS1lX1dNsLJRjjZcLy5DVlTxHqLbNy8SbfNG45niPGGFjaHyIbjqdPmRmW2yMbq
m1B7XVDx5l5ptspGOtlIXzY8isF93A7jy2bo5s1w27wBRGlC1pyJ8WGy4bGUohWjRTZW34QD
14UIVKhqLsl4q2yUk43yZRNJ0DhNzRlvkY2bN8Pt8wbsAB02EZPDZANOU6SaO0SyRTZW34Te
Q8FSMLy1C62y0U422peNkGBmNadf0i6bzM2bbPu8AfM7jpuIA2fZcJkMWmRjjCcbYcJQN/ep
wTbLZmTcw8Gfrisy5LJUfeveHvjmV58/npXZ0o5cKyP9843L+sjlw2T2EHz5cPXT2V1whJEn
gQx+DFkQVrcHwI61m3axv3mBnQt0TV9kP3fswP3jGrtQWu1gv3iBHVT0LvZexf5j7DHGzJ1u
VaXmouD99VvK67D3IgxT0gP2ruaKQrOx2ZIp/XSfJPmgW1X4CpKCwkYx9rTMOnIYkd6wRtYw
HA8e5mBdrGGWUhz0ZP4XmD7H86+z+m+6njmdzWdeA+B4NXXqWgPleQ3W0Mvnj8FiXhSTut4S
AhiFrlpF7seywa+CgZ90F/TOe5fuRmLzygkpwaM1GzcDn3tvNm4GkBjsX4mltwb2AsSRBLPs
qz1GHOHBlL1DRcJR4bh1KNQB3OPVwPEaCs7bxlsOhWu2ZpSw/GHqgz85SbplwVb64NoDoeNF
p2NRDK9UyuKuk2E2D9JkQUUWfR4YLo9H6xiPTRZF33aQuK+ve5gPiLcmnSBsk6iMdRz7fL3q
1pl4ZCfqqODECzYGy1eewD86uJkP54+jefB+gpHhy0nwt/vyr/+iNJDOZPn3uh3FY7xhub69
treF1UloW5+UDb58e3F2Hnw8h7lOt3kd1nGPqzTdTn+mNUlJgZPZMBhOJ/D3QzZzY67KJTx8
wmuJYSnUHpWYOsOwfwxRRcle2KG7dFO0U4PokHwD7xCagjzx5BrDSNbOrJGc04UbkaN+ptjL
PoYlUFlLXP82ct8P5kU+oXDnrSrQUYIEFZkcrEYj6NvO8luIoQSa6rswvIKKdSFFhxEzvKzZ
dWFY1WAADsPowG0Xh3EMPIr2acKNuAH3jtsQZHiyZBl8/Hj5yUs3pVzYAtNyzLG37xlYF44t
wvQ5zOBczvPiGEbgBPf4kFXpJxSgTBlEWV5DxPZef+2Su/d1sqS6OTCO3g+uHo7jViGeq/78
rtfFOowPwW+r+RI0/xD/31cd5c3qGPYpXtHi7y+E7cLuX950UyQsi9XaPTfvKCyuAirhXe/k
HFGwvIevoxULJaoZ+vHdhG7lmxQR0IBymC1g35xd21mPStxRwFINiSIo7Y9rzOPFa5ZrjOAm
DqscYYAuCrqNGGDOri0/6fVW2TPbEincCwn8ghYkY2LhkPheSKOwBQmcBCEdEp5lDqdJwO8c
hQ029ij2aEu3PT9sTRi6WyGJvZBEK5Kyh1YlktwLCS9RN5FiRqdnJZL6/UgcLcDGTOqWlf70
eso1UEcy4s0VR9VlFtNmWElrUEkjpIQzI/HegItg5jViZHlZ0bguqW5JxM67JkDBO4/Wu6YK
Re68ZEIUHpnWq5sKRe19u4Ro+N9LaHrvayVEUxQ4tFNVOwYT40Hn7fl1kFGw0qRATdmmxEht
vRivA3gyjMISb4C7/E4gVQKxDSRw3xQhdYN/1ChFfbWJF6x+l61WxTbxLw8HNCMI+PPF9T5B
SDBBJN/oir1GAIiTD2CD/G4cBSs02iO4xzFg5vxdcHN9vsaAid3D4PPV5a9Bgfk9S8xqnBVk
ok0pkKHjIKIYt6kmxGq4eIlJKtxFm0zL9EUmTWFDbUxX73pPooNlJ9KHdJzMME31BaCYb5y2
0O3mh8l0YjOOJjnGsIDR9hpdRIICg8npCx2GZvMmCXe8y8tfo9I/RKRrcPsnaHVlj1lSZA4g
YhuHIgRwZkMCKSaid0a1xeCB7ikGJ6HoG68Xkm2cL5Pf9jP5CaUfAtbJOCjGCSxkENfNp4/r
FVS9atXDNdMPXDG8HbSm6/mHXsCqgulVPWIlalrDQnye2/wZew6G0GqGuTJ03zwCB3magP+Y
FGQw5Ml0VNSxqLyjjaKLsipLh2iGdW4OjDr/ydGCDQVzHJZIv3iCHQDjy5JpbaaAuWpwPj7Y
34AuH5IHU7oYFZ1hsGrxFOLnX3mA8S9veydXaM/YhDsMnwmQDeGrctMdx8yZDkvmfViijuEi
wk2PcuFubPEPClL2Dca0SnrDktwcpinGsqEZ6lBgO2ym+BHkngUXuUozkYlQDpPGvigEA6eR
Y2ROXXBRiU4MT4o3KXm6OgE7Gb2j7snJCVb7zikDGcPkQNI5RfsVWN9hlDxkVAEaPgoM1lv2
yVN9Sh5PFUNXcjAvMqBE1v5sbvsw/hd8U4zBMYEPNX0E/KslfDiVwST/zbYChKPfiv6wDD85
ZfRxPH8czkej8lPFFtlWBvN5sTwNXzPvo2tF+9/WsAK7s4RVM+sXWYqFLmwhjHSx8v+uGw5Z
MOsPkhz0dd5PB8gwn8EPrp3qi7qrtZSF0mie+1IOzuFpSQ9ggnX5bd8KlnJDa2YJNo3Zh9mN
TANAxrhvrAFsabQKvlzjbfb8/TVFAQ6tMi1PjfC4jEKz8JjrdfFcgFoo08eP19B0A60sWA8e
/TNsTJM0uM+TNDtZZPlkPvQa6tQoCvRJ/EcEAkazakr0Bb4NoWhmKO7zd3dAR1w15XBQB2B/
VX+oA2ClN4f1kA4YUJB7ScAu6fXGDTfijzy9AX94r8ZRORWNtiXHaPutbXv93WwXZt7WVVy3
aXXceqtx+PIKdB3daDQWIXq4Oxq16rDRKJjzYYOzrZebTYILtZfCSQejxzksUtesxMMViqhq
b9br53qzyChiDDVIVrDevXh3bHSWLbEuT3m8HBxVlRZeOWatRVNM27q60XLIQi3qlvFQ+hS9
JfvFUQj9Mgzc/7DDZdQNX3Vp18tO/ZB8Iq1qLMFOkNdVSqgBwdHJRSMPHqfAnH1MWgKY6YKK
c50q+9YI8gBOQx0MVmiYl59ZDcQxcPQu+NdgNVw7h8ffIiZj+O3iw0cyWpLHR/9HSZPhCo+b
KuuaZtA4CybDPrqLj3gm+pA9kwAco5boQ/xUfr9G3DjPJfJY4L2/T15Gl7UQCywC7Z9aXWVo
Tf6QTkbFD/6xO1XtApLq5JWYBV0m1C0hU2cynCaL1qYUBaXPlpgOUx7dg/3ViXjw5d1jcg/f
3rz+FFy8ffP5/V3HscURepEjjC2mrO2j8oidEhN0hys3BWGfxg79N4p4dvvtDR19nwaR4OEx
fvHBfuY6Kl8dQExg5EMDvfeXwa/veqUxn6WrHOuGJUvwDgcrMsrzsjTZMZq9tryXH6CNWLAp
YC7F1eUHQKr6yJvTBDw6NPvn6ajga55W+rjCv7y7EXjq3PHBpgXa79P5ux4PPsMvNNPKokGO
p9Ga5hy32ntq7D2ybs5N2IzwyH1zGmSL8c5poI1AhY601YoIjqbDwrrFQcTdAJlIR2o9y+tL
kK6WwRjQg7uNRC/iURL79svZzdXl1fuuLYvAsGwU1n8AT8sKAIviddIuB3t+sYJlO6MbAPiy
+Asmz75m34x73pjRkdc6FL5KDxTLV6yAmIMhewVuxjJBuQ5feNnffzgdE0cSvcV/VB4Revnf
89091KYWOJfOMcfuFs22rvvJGA4KJxiuQMXBiKcPIIkUIL7B5l1RhYxJCQBBvw99ngHFkAPF
iDkCHmJIdoA/94vH+ddFshz3Z6vHx79gwCPCJY44Mmgp7x6CkEklsXf/GTzMqchUf0WZl0A6
AEqPUAtJkGn+vECfArT8IsE6WNh+FGEHhHTkMV1aAi7Rz/tpOu3bAwriBSaNXdGuBUyBk+st
AJVASSUDR4VpMgcCC4lX4cFwDsKwVJj6BpSG5CZHjlQJjJFB0kFSTNI+VU0EygSHI3XDARoG
d0qUG817K5ARePaoilAkTL+mfx1LHGO9jW0MMW/Qc2jDUBNY1qp6uDCiPkfG0UUyitdxEQ6o
sswRSYb6G6Cw0fm0DyoEJ2IEvuI34Z4LvHFUnaQRspkt85UFI8w3SvRwqCN47EFCOsLxwIrj
h6mTMAojHOyd6gT3DtByr8syYqBaoK0Ilgl+ARswnTZVYx7FbgJSPZw7u49RAaReHxvrf7o6
AhzYXP52GrBXa+Rilyq6tWoI9HdQ/vdL+f99FFMoYFmKf69iCvG4Q7YqJlgVQsc7FZPQPLbr
7clWlexjYiguTFzy3ooXoOfMSxpMMonOIiBtqiUdraslyTktr3VtN5rWGkGomtaEFAXQittU
dwZgY+rkrvkDeyQve0uPjWAp0rg1ZUCvYMMNKJGg+vGQbOD7Xs8Nuyy6ky2UZtCg1MJE+yju
GNb+AYobTPw4Oky/xrD37Vbc4IWRmjoE2ERoq+6huMFLCale0C7FjYWsND9IcXMGqkrur7g5
s8V9dilusJIjGsKXFDceeWEk9C7FzbH2QLRLcQ/WFDeHvTRihyluHuIR3v+vHQgbXaR22oF/
TPlyHsb636x8OZcxj1uVL6q3SO5SvuArU0mzrTqVR7BrmT2tQh5xQWi7ByQSdCOyU7mA6UFp
wHsqFx5pZcxBOoCDTm5RLnKwplywIkN4mNbiImLoL+2jXISgcPfdykUoWW5FeysXAW6bOUC5
SCbwcGincgEnHI8UXlYuMlLU313KRUpRKooXlEu6rlyUvaDadUnrdRmLX4CYqUR5f/mN3pCz
Vu7hiH565RjAOIFRtwcMj8kzuOIUfHmfzbJ8kgZHg+L+VXXIUZ0DsI5w7nHyT/CkudAeJuw5
0O3J3BYigQmEtR3mbWcpXINT1qSti/F47vpReZHoWgHbgjc5p7+dtDA7FkGXoHSDg1VuZ/f9
cfYIuhFPbMqqv1RFo7pxJCYYg7hkGmffUNt0qRAMODBis+gGshimZMUymuRT1JZd71wDD4af
HTUIz7iywzle6dsbfaorAVMvm54aeweHcYBYwrgYQ+/RqnfneRxWAYat3yITY05PxpzCOgLM
5scGbHWUh+y5qEgE7DGYDRCgisVBTqhe/OIxW1KlW4xrG55KGy5H/SmqT2XQQfWR+n3yT5BR
4XomwWjHc7/vBq8oFjUILoB32f6IEu9DIyKqUtHrG0lYM0aCY+kuMyXG1DEMqrTSDGtpYkIF
xra9IE2Y/tLE3+1xdZm5+b3gsSK33CFNrcBSYu3SDJUUSmDIycyjN1Sf00qT19LUOmRk0W6X
poE9l6y37/O4WHUFI0q/GzzWld0hTRNLRedbbdIEQyIyOmSeNGExMZS+lWbUdd/HsX5ZmrGM
qJzVd3rcOGZSie8IH7FQvyhNhXV1Y8G3SVNgsQwR1tJEem3DO6C/GHlCSte+uCOEvTFWsnwB
FNEaiRJGyZf31ekqz6mmsVPbZRUMusGGgVuOUd+X7Rm8uNYYHdqzF0ceBb7RxtbrsLQxPgtp
IRtzMFlOk3LvEYphXeTN3Qd5VF2UqL9a4dt2aLcym9RadBh4WmjUE/UiwSo83eA6n8ztpUGe
J8+2ppVXj7jm5bFCRZfmacTBjbk57394239zedsLTrEiMH7x5m1QfVGzCRGhAivZNmpXHVdl
z7ACNA5mGe+OqTOwWWoVoWrJUocHJKbESzf6UZNJRsV3K7KD2g0llqzRa+1yHkV1u32Y5gN6
tQreDGwpyAVMkZGUEWV7sT+X5piCkg+WYNcSSXVvAb8asFQjnPEnfwejRMfKfwMr/q7AgpF4
J0mlY/C9LS04ErO1ONXMQxytQrGGIzEpguNsvF9M5v3J0uiuvT+qM5CQRjON4QhIczKl17l0
Ua6DDFeh921VmYZuqbI8ByPypHTbCIbHGCpZjBfpGBBq//If86UNJsZgu/MqXCSv0jBKCxUr
9wuHZbN/gCIZDazjEfRuz25uHYVSaKD8fHkWvM+TxXiSFpTsdV8qkPPxZIHZF6McXN4yI4KD
EexfLDswE+OZxP7JRsPH0aDmho0Sfaq9uYtpka5G3xw/V2ifjJ/6T9PBqnAAFKxYJig9g837
1PdblXSMsXrKCpBRN1j7AR6mlyXkv19gbe05WszHHo0ii6Gi+RnW/NkwWSyxGKUjgpULQDfZ
Uwd1g/s+Vhjs9untx66PcHSO7yYIfcqYUaUZhH+KyuwH+B7maYhbWt13mJPTOQwMzKhHjNIs
gjHsRcEgy2aYQuNiEvMMvMRiHMAgY+gjKMkB3VMOHbQOaSgr6CLF6UaFO2FA8uSrozQayxbV
lP5MSZZeRY7j6sVkmPxHMXgpvnqdV7/a8mH0ipiHY/vS2vJT3RYPDcaOjwYYvvm2d0ZJfdRg
la2zviYVnjEwLBW+WMEmeD3/CiRvVsslzOykCF6XYfSvP1z92vvf3u3HLmP49/UvN2+u8G/i
s/86qXMUTp0c6UN+AcZ3d45Qk0kwmSfL4TQpq6Ye3bwK/mc1SR8ukmUC22k6ns0f5/fP1ToW
VY4aIGgZarlHGmdVVR3EbYsiVwAxAyeX7U5ibQKUPcBtH7yDXQBvXgAIJaO8s12JrFseQYFq
tpZPDvYIpniMJ4+gkezHSmZ/vilfNdDFenws+LNjBodB4ALNQVnBXgNWxWvYhSSra8aKgMqL
2RcDFuPEagv/HSSII7Gc+12VHUJvIKGuvv5E5ZFNcITvKz0NxDFVS+wPktX/8XatzW3bzPqv
4HTOTO0ZSybBu2Zy5ii2nKiNbdVy07yn09FQFC2zFkVVlGwnv/7ssyAJSrJTox+a9xJFwj4A
QWCxi73NcARzoaxjlK2JBffbbyCDkNNkVWEigLQ1pNSQztshQ5ufdtjizeKq+FbkWctZQz9U
6HCY1mLV+HJUVxvT7Uafb6UKOtFUtKQgNK5Wi4wO8Yq0J/57CHkr6SYnj5y+DnGP1qnlnEpJ
40SkjxeI2VP+JMXgedV6R6HP24RIix4NlxfJtKAjr2znxOSWQYjjTLW8IC4XL9n/m1uLr8VW
5FsSYeHFrAuAI/YGM4kgthwp+coWYBQGXMUgXmW9Hv81URWZBjc31zfEN7h8DLGmMX4bnjeU
SAxDyzp/IgZLb2/l0NlFEOrDcKKDIt9jbNjrPTHAWU+8/hLeL/T+2Cu7KSCFnJtIC5eza0aq
e3IdiDBVT/zXbNbr8QcebAN8oeQKYq/63quaG1yqakSfw63/IaKGCTlZgIoPjeerOZyd9SnN
EbpO3Rq3B1BmP8bLOUvVPeU/xvkJ6++qHNRWN+ra4mhDTBLTZIdWlaO5xBGynpNUSl/7zbfH
Xd2LVJHk8Rq7erJK6tAwlcKwSlF1EJKl6V2+v6roEapw1ik3X6HabDjHf3jCiylAhsPxaHRy
ezMkgep28EcDEbps0F6srDojZo1GO7rmfR3eNcvWyMPAh4fiBckYq69qUx2Vx3Scziw8reyG
4aXoXw7ZmtBQRZLrZUzXtPfUjXXbdYhb+Lx8UBjm1SYBO/KWDwSCIGliEp0pKVPWQcOQr9Mv
LxE7XyYolzlBBUawpaqoPDULoJZgb2yylSOfnxGNXGWgdbq2buXbWD7ZNI/LnA7H9/R440uw
ag7IaCX33L2Ctbv74yLB20OHs22ef+1kqFpH3Av8fI5J7go4WuG1vbvSJCFP9+JhtsmZ6yRr
xBNx6ZeyJXqeVCcTNFXk/64LmTVAtsX3OCNaxBvihmo3nFeHSz3mJZY0lg6c365/1sS2h+U2
zsBKl+JTPC3FmeQTqQn3JqnR6np46o5QsuELkeQa0fXB0S7Oz4SlzohxCI+693WLMCSWhyi+
eIms7PxXzf5bEjfXp2yWbfGO175eriSGWY6JqP+YrRDSQLxIQ0gf2vqbIWaLpdTErudxta+Y
73syvrrX0UwqkwgC/jthYLWG7XtQXMtllvTOsjIp1J3/1fCs/c5QZKVLkkSo6UIHl1nTJZ3M
pEH/8gmlbsTFWTGol6f6CV3aVtcRR9fJhlS/NenPJxDnq8SuhBVZkqvT1ENXCkMihvJa3PRh
vqz3C/QsLmonvHmhyZ0QfvuqVNRLADqWYN1c5zOhx4utbh7HCfL21rNrY9v/jjzW8o9OQsdo
kWtKUpGIMs6SyH1+7mkI9YUY98en4/5tf99aQouWpmJ3s0ZW5ELt+WsRE294Fr+3o8v+6OCY
6Ak9w9l0nZISqqLVPr7vV9PdE1GXY9Dpv52H6hkDpJO14ZGWp/O4jBHME9BWpzcZoN06sZuG
fsQv9Ozjzfngs/gBBJiNCVFNsiLZLH4Qyr6z3OZ4jdJxxLwgYWhKWuATO/zWkRZcPFdpy7T+
5mnTRyBtRAU5bDIek1YGVtnS3HdTYMAts0pggfTPXQSpWY5+tMC1JOediNsrhHjBkaakFdN9
VistpKkPXb5AJpIqk20dfh9neb296YGSGI65Mb6phkSMo3ha1p7N3AydbIqC3ia+pXP6v3Q3
dH7Qgr7hKEhegQ692VMXr7f9uNXigIheKbFMHTmwZi2yafI8n2a9+oOyZqoTq0dLIF3QI1cb
vRZXEQhGIl5NApmDRIfOQyGO+qt1t7Xx0FMkXfjQ1VC37umtVwFWmxgobgXjvQrjupAxiHuU
2Q7X0uznSAG1aEiyoDdRreqrdPNls05Jax0OdwcALpKBiQSYJBKCftpCCWYW4rbgQg5J/e4Q
GKpFEgUIdvk+SSr594bKpV65PNaSlgn/1LaLk5K+eVfH0IUObb3EsTSpw3G2ny95+Y8+t19c
Z4dF0ObsPGg6N/L+9hrncUIMav1YJprM93ETiLvuZncg3FJa0Ym4y55ZrbnjbCIc6nwiytM5
SZDzElHDGib0YTLkwV5y0hkwn3lr+Vpd6Ymmve1IZMvA1HDWZqvHnycsJvRajxn64nceEIzh
++QCvIBNnJN8CotnsULB1mfYO7fTnPYBZ5bn2q2ImqD5yJLaPMA4AWcL4GEQK+X/iHMO0O30
1aU8/iguQX/0GIX6Y9k0wNEvcKHpX41JVQ8abKR5pMVWzjRyf7OJOZkHd1hbzMu5VaXy0rQ0
LEuz2eVjnh4wVmnEWBnVcyNmOKQd8qogZiW4/C0NiY3FXBOnMkS4MnIjP5CRB+ZX/ysMNVyg
9KHNDDW2e/hQ8+Yj+kwf38Hh51SN+FgpmVMVLbvIqqONgaKA6/jRAffhi7hbQKLEnRdfm2n+
y5l3VJ5c1l45bxQnEq8q/tCxvtVP60ifpduKNeMSQLqunmOHTrKD38PW7x5not79PWn97nu4
xNz9fdb6PeBShju/e7GtfydZ0N/73Q80vWuxenFD7/RZjC7PPM9mHf8y/fYtXsJhgX6qGGCX
RVw7iqITjh26gtK2AMNE1E+luTOowzG+7UX5ezmL/6hKTHu27MCE0dQk5Mxj9G6PQmKFqGgQ
dpG8JnuveZ3r22BYqzyhEfZ2IpSbNh4JX/Klbn9DpB2UFhDw+Xl3p6k8VSzxgAq1tEjjWZZ0
wgUOEqPZlrD0ygwCBwv9te4SFehR3Z1xdMvs4Msmgf756Jq13otf+00HLNr9Af1HXXQg3871
Epf+L9z+MIF0cIz8viSkMsv/YOex6lo4nk0w5yjZpOpbpOriQRTbzWq7UTYVxcBYxGDFeXIz
6J//B05E2/USwfa6K+S4/Ze6gp35X+nKI0aLUhv/Slc0heG/1FXIqYT/ja5sm72f0FOvZjq8
Rk/EZbzcksaIUMWqxOpzRIcpL2f1TyfSOI4NVVDh3BblfTaNxVX/6pwrNmXvhX0SfhYh8l1p
GjfEOlE01AwM5ESMP52diHSNKjlVySdf/Iwf+G5EfUUM6URcX79vWmjMwAdLUadFUzIKyLpJ
ZMM9dxeulQoNbXBKw5pEXZC8FeuR7DWzOf+vOiB3hqubOBIBXuitrE5pJFqQtuvqNq7PqYC4
DeowK0BUCNZtPBbkkFDnKZtt7nsi1L8FHJCEoE0YmXeH0+om9GAvr5u1JkC/Rxmx0bFuo+dY
wzh41+0pVrZXakq9OZ7thzsT4MgQBy73Fs9ma0hPPIs7mCTb2M1E7jVzdDOPM7uTPIfUF1iC
rp4h5EqndzbGya9qOFerGTWXZtWZ1bQmINgRmxhiW1zenkNp22QqrwbJST+8vIB/6GkUh/mP
ytFU/+lU/1T5bi3SvxUQbeXtguvdNN0I64cGK7BDWNc+joenY5KXk/u4UWpbSj+3dBzw8gGJ
d+tlumk0+veFkuBqrf7RgebDale2EDJgxcc+1jh+BD/GRm2Pk8dNvDoQKW1TkdILLRbESZNc
3X/tiQtWGC7Ph9fiPXQQtuPrxwmlh1fxmMBn5HO23mxJxDjrXx1cWmkKl42G5YJJSrZHCfbW
/D6ZxxVKKjISDuoH0RRVKh8tG3lh4GFZAXj3iqEh0k0jS5pc46V5OalzdYI+QjioCX05A73e
AhFisQ0A5nv9uxzykiRBQLIRnphW185D66a+xxWasASLEmbYT1IvyPN9xRTX4HobRyEXutJJ
PY+S6ia2wkMxTBKzeGk1b4KNHgirxXVjrfzjH/WVtuzCT5+1fKRuPNm9aSDl1Ya/VGpbVst6
PLq5PkXpu0oobi4uHYC5nQfZuepXJg0GcS2obwqkeQCMH2I2EpP6up5n/QiamlaTo6hfGMP+
IFrzF3SdrrQ7D+HeaILIDxq83fn8zniaKSWW4yEt86FI3Oik6qIhq5IphHbXRnbOutOdshQi
3dwTwBGyNznO5cdvPUeCXx4LT/Y8F81s2XPcXn1DADDJ9xqvgr0+R2eqlmszvQBzJScfRbv0
TfNLs9r1O61n8zl2qUY4eMFEgkX16pQCIoiwB7P5tDWCD9k8RqrPZoe8+qa9rqsvcGxEU7Hn
HsMdbhiEwLjfGY20JGe+yJ7n0/aMEO+rhwTlcfC84gP3O6OydkflBdByK9gXF579+sIDQMDB
zgA4eFEfpoPXR4IrLpIydjcmAKPAjmrAl3dC+L0BwROAnuhP+Gv+dJkla+rrp8sz+eULVqJ6
aS9cyIcaAHW/SJotQ5IJrC6xqCvugk6mcZrDIjXbsnRzPuIW9A6wKNXCVMit0XgRu0sVi3hN
gtY6FRfxAkateghuZfvjxgGXWNwscKrd3nNRtE84rvQVcaAbRzbuN1Rjq9FLmwwIJyr5miXE
YDju9+rbJ6KUVhiZeJRl61ncaY4XAMjA6HgsN9nalVZrBHQS2wYAeVIGQdiiDziW6s30D8QK
v31bpJ0yW2sQ+I8ZgURetIPgkM4VcTiOI0afhqPWKel2akPCfJll0/R/83XWTYrunytNTdI3
jPKLDDbxUbzGa1sos4I2qytbOay2gV5VjsvOkKPRqLll3FvSMHlI3d7nTAhof57SMtzA4JIz
q0Djyv69FyDDhIhFoeVLD9drRfuE9Hx46q5lR/Tht9vb/4ijWgarJS8OUHknPf9YHCH75Uak
yyRelRCdAVNdxRzrx3IRzk3ihOoOWejp/2oGYEdhhKAnVcL6juXXX5cZD2rzFd+cxYuMlIRl
FrcgXdvIezLDzWw+aa92F7JCc2P/mD8TB3HEYyXewkb6wvW9243BZ3dZmxtaRlnnSSRPNHHE
941vX67xE/G7htxT6XBWMAFCdGdjjiOOiL87p5Z7Kr1j4hjq19Pqb9hhkEB/sMs3NabrGz1P
1bmm9zn/xZvp15tFaHuaDcC31SQP/5qo9aYgMdQ1YSLZ6r49ob4dgv/+nUGGpq2xx4DK8aAf
X8aoidC/vRT9fBqXZTwr1oenkqx8lpmQtH63TfixWGff4F3562KzJkHvBWp9svihB45NuyOV
LBBdXN8MxJirKZQQQAYdKF90fgD6YD1b3SpEH1iB5UH8zmabgGQHWblGEcfSNq9A3s0SX1OQ
wG7xIUgaAcSUShjQHjCWftDA8ZFkIma3lbapSL/3wJNIqFGru3fZOn2i/x3ou5aZvgvkkDl6
jbzNin1QGRmDwgPb/5uVQj1NqEHFzTWpG0BEjwt6Zf1iIB5Dr/E5K+sUodyQFpbJiXr/FHfW
rX6wM0z2gk28rDO72+7IBaRQOK1rCPopL5YHExgaTyDKNtFbSe+TbHKfzHrMlCSpFj8Olvdc
juFH2g7lpm1WPxp8PBseVytNI3mc7hJInVWS9QRa8ZJc0amE8rX7PC7yOaRFUVRtKrL66H2V
NHQRSVbsDJtkOPHj9SpdvjDk6xeG7FgWm3SK3QFcv2EAiFCBPLndGUB1ZtLRtd//8MXrFuC4
NrKM1EuVXjLg9M+e55iwcay9+0STB1wx+c3kT9Syk0zjO40QcTXDt5+rs2QSJ3lDb9sWJLHq
azVN/WmJiOxmgtgo1biE4S4SrUhyAgOF/Wg4Pr8irsVhDqWGdiKjU5saLlaauorCMKDulMqj
RmMEXmQyvdu87MSLeDuLNUTkuiaSMiCSryxeNhikVvkmiwQYMIfcxVONoSI/jTAQ958U+l2T
IBSaPktWzlrai4MT0HQYD4ik0wjE0UxEDyAUJEkU26QRQEh9sCOjGkYEUs5mayvSELR3TccB
CM/TEKSKGC1RgqDG8aZB8Fxbmhxd1FBdFGsEEuWM1laNsH/eOl4QBQqprGIjsMtVnMQLlYaY
DxxgIA+swWjibJ3EdUUsAKDwhmM4iEMQh8MH3j6K9QMtKF/Te475IPYxSD40WV4kEjxky0mp
N4ofWZFtOIr3jCJOSZshBl7k9OlD8XE7Ldu0VTxa0xGcEo1UM8XeJnmoIVyreu9vH+t5+onO
7VQM4vXmPodeTjQa0Q8q1v12xI/D887/nF1fipsxfIgOnjPyHM8Q8qp4gMNXv+NK8fkQkkRm
IxWbGiofK43gcs5lo0HtIfh8ufp2+bWYpKRINVn9GSMIQ9PZHlQgovJOj/fmJrJ813S6G0z3
FUzHtUz3RIMZvoLp19ckBpij7KwdWMg4IWsAJu+h8tJn6iiyTLlv82S3Q2G/+HAw9Bgvrzbs
y+/WhdhrwmHTfJXONbVyHjca1B5CZBupfHek4zmNnu2iJpXprFwA9EFcAEmeXuwBOpY0slmS
SETcfr4qNYQbSdND5wPDiA+jMehON5uvGk6ZxQ1ueJ40bciGEaOhDEe/ZchZWHIlIEJsLxep
8vob3Lq3byFdKb3QdL0Mb8R5sZxrqcCVrmeka2Xb7WR1X6TL7Flj+E5gyn9exAkdy2T/IKfH
Kl5OVlozcREEazorPyscMTrvaxzJ5sJ/ioMYJJIH1ulym6fKIHWssT2O1DXC/kLiHEsuA1I+
03ksRh/G3+8ksqTRZC68B2psW40k75IWbpmu+J8/eT9TK4I5h8AVL/LKmqtRpdkezJEYTzpS
A7ieZ3ooXJ7dil93QHzbiFfnKen8O/vPRcoi02EAhV1tufGmqNo3oEhWY6JJ5kUZBNLS9Dan
QTUbVFEm8Px75VQjsd9IG8OQQrc1JDoS/umQAHQKt+o2ze51mOsFoWWivxc5fKn1evRU5L7R
+P7v65fBJ9p+wOrCDrJIZmK12JaivUJ8m3OGvH1kqw2MyZrekZbp4XeAobIqGo2hTe7L0FQm
+DC+VNdg4sjuoIFmSrRjjDh8scn80As1feQZv6t9jMC2jO57/krirT6jAllr0W8fwR6CW58s
b+1/93LDDTw/NN1Qv2zhZJDn+o5SwwWO0Sr9a0taaXKvWWkQRo7pMv1FgQi5nOG6ZJcb7u/w
0HZtI++CVbIKn/U5FsrIWNwfj85GOxgue8W9fQxf82mx2HtzqDRs+uYUkIYIfKO7pCfUob5P
9e2aG0a28SCqM5zTsBDb+w2gHwf92+9KIBFJYqZb5bWONCi0CoPnfy7TZTnJ9eNHqPBtOKpD
kECa3ejNtpsWC4joLZos6OQr7O3NlqWVKEOTu6k0zyRqrdeZRpXX8VrjSTOpg/B8+T08J8Bm
udvMsknK7ki1xknfdPCNbuqxpeXtOushgu+FJgjZLC+2ZarpSXwwefh1Vnj67t+zIi8y6Z4a
IqlaQ4+KHKaXZel9mW4muzCwqRvBlC250SMOG7FMjW/ZF8TvYV+MKp+lM87t0LJ1nan6tsoZ
CTbbT9sESQ6bRE1wHfh1PCY4jivRPflBYOmerq5vBz2V0IWzMJSrNMFOXG2p47Lpks4GGIOf
xLKAOxtnetOQkeW2Bl8nPy7FUTrvws9oGi/nx6IAUDUkmidgrmofK74qb64dPElMpoU4vOOk
OX8invEppqdEcHjFqTAyVb0AvsUIEGeLHbvdpbEepKQ9YXLMllnZkiU94jfS6Dr6OU7WW03u
B46J0EOvIZ1ttG3JkyoL09vXVxrPF2kn3miuBfO30tuy1USh6M/KaSTwfebHp8MRfDlTeDha
2s8DWQtw//3Y2K/rTxMOPOiRaBf2OOt88wsCLTu2RnBseHk3vz62TeHoto5S2LOFawASmMIX
ATAP2DMI5NHTcyJQtJcjbvFD5fTQGpDPMbp7j8Q5f3qRZyFAcQMvnuZbTRlEMOa/TBnSRCaI
gKF+VXnMup2mj7zKSI7/2SiEpR5gN1gsm31Ol7Ni/c6e+VP8c7Qu4O/6DjnpGjBXRZu9CqaS
aZc9cXm3fueciBpEnlRn7xVPzDs9Ma7jVjc5FWJF8uY35bpRZcGpANphb70qxvv1sgYH84Wa
DHYbrz3w3gvtQwkH7fvtVNgdq8cFmTEj+KIVLIqWqozd/rLeTidVipKexMZAzPhN+peI4fr/
9DlebFMhI8sST8PlLH3WDr0eHQfW9wH/n7Zrf2obWdb/ytw6pyrkXGw0D40kV23VJThsfDYG
FpPs3rq15ZJtGXTway3ZCfnrb3frMZJtLAkIP4Cxpj/No2emex79SWF3GPs1iD9tRt0gGq/D
Vbw0dYcXz/a1sggAE0YnWTAo9C5bWeguHhMTUBA2ejLzLwhh4NJSNSWbEtHOvWJMrIl4sUFN
WVlNHaoml7gajlaTl1fTIPZjc1bRtj0X90ObVpFGlqiGVQROeHHMqSq1kJbMSu1mpS7kQNne
cTSFsWVAveMbyPwlDCJEcJkFxXQNkhZ4X7tWFZha1w4tKxopouegOGQRVfFwEk6nMJarhPpy
g+x6wRZjzsIQ22HZZTz8gj7wgjkGhicXNcA5zBPsv2+u//h4a2Q5aWKlrBBp+FMSEo7nNGxP
R9FGzava0wy9ju1K+03a03GUXdF98/Y0+uS4dA7557Sny8nueVF74mFgt2l7usriFb1jrz1d
mP6O60B1e0qDBnpY0Qo129MFP7PuKG70ybN42a54y/b0hP3i9kR21Dp9u9Seni0OmYxH29OD
mb7BfHywPZVBw0tBb9GeeE3SqihL3p7SSHFZ1oI3bE8Nrr5+YXvCLMDLQ2eN9tTg7suG8yde
puTHW6C6PW2D5tGCwxu0J7r+FSN33p7KSAlb/6zxVnPl6Tpz4KH2xJAyTcdbvKwvjve1/fbk
GBzvle2ZH0rTwiKyujdoTyF2KuBIexp9EtKxf5Y9pJUlyqZGg/ZUXLtN7SGNO/BN21MpJV/b
Px2DBv2qwjCv2Z7g6uu6Jr7RJ+XR8dWf0542p3s7L2pPnAmbzp8aSckqRru99gQ3Tb/WXzGt
YDvybewhjVQCdcdbo08wx/00+xY8KDqK9qL2JA6lpu2JgV0b2rdaa+/QnGuW3WAi65QlXHHI
kwAJWufjQvN8HeddupBz4P7L18L9l521QDDRHO/Iinc5ogctNLYw8KCRFyo9+BquhvikU/ic
ZFNaIs8l5e2ZnCiyY0LXUpD+5uoGfg3ORLEk/wffWqDmnd8+dE/x85TLTv/6y1/JxV5tncIv
RSGz+SkXBtrRnKLnrMNlJ3kDA4jCneCSqJFDI35H7vzLn8/JmRe6lkb73AT2TqPt3a9x3Tv4
Pp5tIqiDnMFomUeyAZHH0cQACYnXS+uwjDwGTybiMcg6ClwgDB2xpdiQ6Z5gkAUb7CQ0FRY7
KfNUxCyjpDgb0VcpIUW+I+nYnHj0UpaL8zvkoFpEM1okhdGDCZZlpcR6kd2mOqN6PKNKLXFe
cPOGZHvyeM4xbs/Rd2NgPFzks0rvKhbEsXAzYf7oYMdLGwCbCc+gB4u4mFA2uusTjehOSTRe
B8GiACNwIvTTYNiXm/+EcbRJCFtxcZtGXPbu8t+/ffzf3tXlO8pLQkrQbhdRGp008ONwuA7m
yzgQBQyKilx/t28eDVfjTVFeNwoUkJ4xTPJRgLELmnRzwQarwH/EPB/Sm9U4Wj2uixpjCgQd
ha4THtUYgaFXzDsy/eB7iuHkx8vrFe8p8Gfh4tHIS4pRuY7HLWI5yz7goix8ZnuolAoKDQ8t
g5KwqdRepZUHVml5Ce34/C+lTFZpcf4fpFNwaZGKQI6bMeDI7oHAlMYwhFC5aHVNiLJUHU/3
qAnBD5sQBF7H7SITgpVMCJKts9ZTNCFQqKkLjjJOgyXPgyohSmgvVIkyyBuphFNXJUoK6dRx
rl6qEk4dfXtGJZymXjwJNfT6UKaJF39QJWQJ7XgrPKsSZZDjC7m1VaJqi2V/4ZWkXr3w+rxK
uFYdL+awSrhWHY92RyXoekNDlXBfPXGoEtoLR4kyyPE1gLoq4VZMQAfWbknq1WtDR1RC1F7r
21eJWjParkqIhr4nyqjXThx2Ce2FKlEGeSOVqNjMPrD8S1I/ceJw1csnDjrf01glVPOJo2rn
vVoldAmtwgx4TiXKIBWzT12VcOvu8JQUstbC+0tVwq0zKz2jEl6dSWdXJbyKUwUHVMKr2LWt
VgmnhFZxfOY5lSiBVMxldVXCE3UPWeiSVJ21wReqhFd/EXpPJTxRZzdyRyW8Kq/rkErYx7tS
tUq4JbQKy/A5lSiDHNfS2iphVwya++vYKKVfvS9xRCVq7S08oxK6jjrtqkTV2YZ9lbCt9Axu
eoKPZEbwgmgTrQJzIs91XPKp99dBePU6SO7jua7loNKswvC7Gka4DGoC4fK2RIrLD/Dd7rI3
rc86SPW7Tvlas7YXGOnRxr2yUIyzgJKtGYZD7GQX9xJqmc2CTlJPc9oVFNVE3l17ceh2OVrG
l5sfPxiGp2KD5WYNDyko1CUkO2XXg96lQU8YgeqvzEEJ4nDxZAKGAYiyiDigaw6a8xZGcmNd
fzaD6l2kwWOzM95tIymI6K7267sDT3nWrZFXEqe57oD/0WffOB7WnfsIYILfpaF5FRv88EfL
2Thivz5t1o9Lg6ElnrIegu5+C9bDhF91mOWkg8F4k8U9yD6SAUAD4pn5Qjj7d6hHQ3/8zmB6
lv0WmCM/hvRPBhjDHkGFnVx9+fw5S/6v9x328G2+XAyTL/L3nBCR7iSAAWGMS9ZtdjMLkMgh
vdaehG3Lz+rjMfiDOEMkFBiGi+ny5L1pO9u2sbe9uozQ+Gn5ZNuTikLpTzH4vpjeI3kl9NAs
YkExTAUmtl10vWskdtsWXkBGYjMMOZxkeTzz56sOu7j5wiYYyg6Xv7O7RP0/znt3BVkKEjmf
tHAnJSndnzcfb3v9j1d355/bRMFJrAtjf2OuYqKkq3An/7awjXKRQLB+l003C4qYHeXp8RZO
TjfUIkpxeNkm2ELVdcrUg0YGerHakyGevw5TbWm3rRb9R2FCdcvSLSHfFwMQwuA9b02QA/5/
oOs9+HE7j7WF+LZrKJZy/PlmFocrH8q8xi2D1no5ChedUuDKEpUpImnLdcQRJOIBa82CxT0S
apiwlYegbE8dg4oSptUWkvkVoeQBKE9a1h4UEiZ2ch7L2F/fB3GhdEhglyPgGdR9BOIqYmPo
cgs6al5ovL08eJwuGVL0uWgziiikJ6jNlki/MVr/WSktzLzJ96LwvauxnXbTc4w86O6n51ai
m+n35mvPxV3I/H8sm0VsTpuZv06yOKZrHqYy2sLL0yOZShJOuZPrfTIK0ODPpv48nD2xLOQI
SngaFbg7uMliGItsoxaeSk7sO3N88XASQY/FhGOiD2Ggs+snhhzK0JdnQdRmd3grKfh7488i
xtl/wAYJg4w+AtEUhYMnNGhe/ylYt3gLbxm1ejf5HBps25gHkwklaaKy8oDBWaBuM2OZtJoi
SKWv+HR50SK1zMABV5q0TnYtuN4EiGiDYR5dChE8B/fGzr/22eU6jH9QGMxyOczr7IRAt7eY
hotguUgas1tIzAsVry06IPtHuBgtFxP2h9aeOIBeEBAc7xRTwaEXjrPW3BpCT5NWEvnXp3Dg
f++UiIVpaljh/ZttkGob0qUbSaVx1E8ls+Czsm2zk0eMbzx7b5JqjufispdgY3PMdpgF19ag
+bZJ7jiWKicXxeTSMrF8MbnrYH9Lk98FYf9+XUwurHax7sE2RIO5iC5LyUU5Oadb86aCHkmk
KGF7pfw40sIJOcvPMgY15VR5eKoGGtyoKMbqNCW9wCSc+N2oh15dX31kvckv9JidWKZCcWva
1P3d2semDej+YBt7fLQKJ9CTvuyoCFflojk2t/8qpieSalQtym3hng2k9mxiFy3mtfgmnLXz
aPnsv4yYtnFRBkYDpEyMbeXi5Z87/EsXekiz0mz+M6vUThJxvS3ZPw2QqxptgCfvMlFHXCKN
wE0r7LxqcOYO0uaHOs/Db1BHochvWSKw3SYLhhE1olNmMohTjwEWAndwCsApibbEm3jQF8IN
krcsIhiATtm3b99gYk+/bo2Tr9uTwMAlhB0FOGoKGPZKXVBYtssL/MJx/DTo9q73QgQ7zUIE
I7ArscNGkweM6jsIxnhCoRveh3HtQLeAwi3BnRylRBpyEwZrgLyOwE9YGAHuoBvxbRTBlJ+P
d678bPPvXTbonvX7F4lqHuYyQogkUGMCUeeVtmgWOzTKYu2isPYwv1TA1moWT+dQWd1PxfjH
GMv2+jI/sxPMVsXMehb6/dBhwImOkNOBSOU/f+weIkZ00c+yUc9AIIZytcarTdmPXkKGJyE6
GcwHi3ZLofwXaFobpVFZGElwFub+BJkBNrPJ4p25uJ+fiSEFMoLgTOlUEAoziuqLgrtE/iWG
A64to100lzLlfpiGfE+zdWPNxotnbgVDMZji63ysBTOK/NLJeDICHzr5A7ZPMJvlEd/7/sK/
D+boVn1Avy6dQE+2OU2MBttftkUB1SFjF4bb8MPlXX5Xr20SeA7uL2XF/9sHz3YyHR4gDRd2
41pw8GZH1fmycDJMzpgZMUdjZ6kyKZUZGB2P6yYLC2vX4WKTi7sW5XM7D4aodmBm9D+ik7dm
gxVKpazD3fIY4AoKJWikoJZp4Dxl0WNITLlpRoo8VCioBFr/6cEkOjG0WZVOJaVmZ/E0kjLi
2tKV59cUO8mBY7wqjh/LR5FciiCPO4SZb/ijgIJ5OYueFvHDKQwWk4Cd9M//fX3LuHXK+r0r
+CRsA+TBHARTRPoeMM94W3eKuCYlV7hMTMjJLXBiFYnBrg+R03axmc0KuJIipPnRwzyYPwOo
pFfowNNvMD/t6a5qrLueQ8HHDOxsudwj5xOyOa5HnuwcZrdEV7FMJ3mJpcUFjgN+OB+OJ+gQ
7j4XtA6T5QvT7OWqIQs1oto0Tphc7fQgH9mhU8msN6F+p5YM5sJgOcTRjCVIlwI7BIz/DXdL
49Jd4Ze+N8WHb3JEDlNzWn8RTmp7FQgeq35FUaPiTCnBo8PbQS8F26qZgdI0KjxMiMimk33Y
rTEwpxuFpkphjLxHcf/v18FTaUjOjmQnUrRcnU/mGGgRzZ0qoaVpBjAH67wG+tTIHz8aMejM
XqVYcQnSiGpepGe/Hw3X/re9rtGQTRNxXVdUZwnelUsg8YWolNiGo7Wf3+dHMU5kcRVi90jq
aWSkwvERCnufkH0eFgrF2IjYFg7AVSLRJFwaGfCuRMkD+PXDXtU2JG5BWE/i2lFVVjZ5RA2Q
UZyInXrZTIC96dPN79qyeNqrTFKY2MG2mSYnoYczfxUvV7hQN5sNp8H3eIgLsh12+eXqotBv
wmj/lDaCKeo3u2BpFi00vVi0IUNhClPY086Sn1Ta5oVxO1mYnoPxE403u1XJG9LVIDz4zYUW
Gq+X0TAY7wE3pHEBYFtQG4ENt4nDWdQpLW5/QsPtK/sCT9AHKBtI0pbkt1SRLSGukbHpdN95
v0uMhBe91kewqxYtOomf7il8WIfIp5Sav4U1LGk7NvZVw2hYQ76wTCVBi9AeOh/0Pt3kC18K
FzTMIp7Eq41NRuBoMWltfG5xgyCdRoHPCQH5U/zQ/9ug2F6jY/YZikbqJYPiEBNzY5SH0JDv
IozXjMoIYUZjZOgwte+AGd4wKzRDrpaTB9PRHOHiIdMluAvTcEYBjFDfrvo9hrsDKXPwerOK
20YGHF68UfMY3wcLpPUbPwYx+xU5IogxOlmjpC9B4dHjRgIj2lAG7Ha2LInrSY5tUB0HXcur
IIaMxBSgNoqIZXwb+ujefO5d/YZxvKRVyAreoP+LLaaL2dAfYyidYq+hXSd4FsR4JcBIuZzj
2abFFHfWF8iB81jYBbFhbDqRtqvYaIOFAA+FKxjUkevPWBauookOxsVkFyVZXqVK+7Fc0MDY
sort5WqJWwfhahgFsYnplZ1wwRSO1pQihKGyd7NVtFDRv/k8SCJ90VfxBpkHzZhgpD26WOWv
V8OYYn91Sp/TtS/Buv42nLBBm/VDE1wI5D1OV31LU8Wfl7d9llYf2HJYGya9pLjUVX6nWZCT
nq1x+h0E9+SV3y43cd5KUDZTEZ6mOEfzcAVuUX85AsXcSeBy3BSJkJUNH5w2ri5lWXRDtzL7
tpEQRKZX6WgbAZh+a7yi8IbE2KgS8IyAtrFG/8TQR8k2wVezL2hSOR7aekQkPi4cylgHfn78
gDatTvBwjLDwDr9wmT8KmffeoHgOnlGsypzZ7FI8iW3WW19c9/sm4UnXv4dZxY9BrQw8V0Te
eHtzUYJfT+Z+YRkosVnaRkoTp8lBKTSVU6LOYwjQ6ersyEkj4VFgsN+Cp+Rgyvr7ejU+sNel
hKXRiCknHB7aFlOAaNXIheJGQrp4ZWUm4iz03Gdxd5O0Y6Lqp+xrYbZWwlZo85AADjCUvHez
w1ia7fGf4OOtNO0jEg+fxNMRIcXIxocdjnkXQ9cTixTJBLhrTelziuJVFGwmSzoM8+xrYZDB
634EQXwo0yiFSf/LRI2EcJTOy6mrCpqQGmz1gVcr4rGs1AzTf8Eiws1n1xL87w7+afPf2Vek
Nx6kb9vyjIUZkzsag01F4xia45MfPbBksMZOOg3vN/i2k1EIg5oUZzYv5MyTuK0ZhyswyM9x
TZkuXeZLmwJ30U1yZblejZ4rja6AshBLM71ggPH3AlzeZ2gb4EICrnBhzGUjAJ3draG/phcp
W2PP9VYLnA17ySYVjtPeDZo5e82qHAu3/PLONFlEQ3A6ljPyJ/d7lHLJN87Tj4PVw8F0nofT
5iwcYYpO6oiwk/lycbaM0iLANHAmlKlRjPkJxR35MZg2Q3+y7bAP7fP2XbsPv6/aDL4hzkYc
TB00J8bL+Qr0bpRY/vnhAPv9juOjbEU2+XIVLLYRzIxjyBKdVdsO6D+WfEkTmh/7eJzDyIKl
jHdoV7NoeB8tO8lc+Ovgeq8ybc/DNeN2u83Ob3oXrNfFM4zwk9/sL2xsIrGAW0z99ePtoHd9
1WHQIjZ4kmbG08LGLSrrlT8GT9n45rfDA8/cfh2eW8JzNdZ46jAup1DjxGMd0cFCGKm4bWYa
UOBy4t51i+rzH1aumCAiVEGEU32mljO5oL1raoT24R8jKS08mJumhlfsPlcSh2b8zuz5/AP3
uvYqzbHpNmD6BtQSsF4fnqJwjCRjiI6HgYoCjtgT6IIRRsdR7qAz5kztmNilAb6U+PPdgOU/
xcQuVKG1n2uOr8czBNzMjy6nXbkCLiCBBQ9yE5hxxik/d4yMwNBOjhGUAufJsuANNGqIh2jQ
csUzYYU8KQet9nL6rN63matTzJkWWuwXQhyoevAIPL2L7a9HYbpJUqp21yNiKkqJSlgsKE0s
nTypZ1HIqd41ZdIqPOAS123YKlzgad1JGBGB+SlDKjF2yh7C+wewK04s6z3Y3Le3J/h3QL8z
lThl3eRxvziGgPONNigB89OMGJ3tAUu+B0zsIqBqBMwJuDAXetrFoYyAxTHg/RxXAIM/JVNg
eaQqpGwGDDa+VFkdq2PAqikwKL2XAttF4BmeXiwA202BHRv3HQhYH6tj3RCYW7SNS8DOMWCn
KbDkeVW4x4DdpsC2xzM99orAu3XsNQV2iXKKgP1jjXfeEBisTJ51kNEx4A8NgcG/9TI9Hh+r
44umwJLbmbpNjgF3mwJr4oIl4OAY8MemwC4dpSDg6THgy4bAoG9uWsf8LcdjDFGsUnXj/C2B
Naf9TAIWbwqshZfWMT82HjcH9nheFcfG48bADjg5WY7tNwX2LDy+R8D6LYFdIWSWY+dNgW2K
eIJmCZIUgCuJB8EpfrpJ4yns9pAmuZDVyVewbM/SOnnEk0fcPOLkysAjmTyS5pGkaoJHKnmk
zCNFVwngkZ08ss0j6Bs2PdLJI20eaQdvCcIjJ3nkmEeOJ5Mcuskj1zyCDLr0yEse5StktIGS
vIunZTbLpRocKzt5G89Kzc1Dob20RkT6UJiH0sEryPgwrRQuzcPkqh0+TKvFOHDagrkifWda
MWYBVFuOLNj1R3/YZLkwi2zaggbkeA77z9z3Bf/nfjwfBovx2SQYw5B5798Xjlppbmksw/nH
Abu4u6XVBjZ6conOax7+8FP7nfTTCIFlBbVSPEHmR4945S4yTrdJbTtYEx/i9TRK/fBTNl6P
pRj/kvxp0cbjabLW9MtyQdQHwTr+xZxPwgrD3V68EqHRUeuU3DXVgk70yMZ+FBTcL81dup2z
IzTEtNEJDPT8fYdN/XDm/wI++Un3PaP/RvAfp/+uf8uhhOXax6DEs1Di5GYHSjgHimKg5LNQ
8uT3HSjwXdRzULycK16Rq/8v7t177TySc7+/R59ixwiQcSJK3V1VfRFAILZjHxvnMsaMnQQx
DIIitzQ8IrlpXmYsH+S7p/slJe5+atezLhKQYxx7pOH6ca33rae6q7q6qh4tNEKUhCj/rfrh
Rx5GlR318XuEKEnH5cDgtdvDr11Kif/+y177KmVgKPbaEVWPhphXvXZ4V1MKqywnRGmIUnzA
mo5hE1dZEPxALWWdIF9lQfADV6KTfSsNUf4H2nFv/Exj5N+q9RH+wLJ/q3LiW43WwzcoO0o2
iTiU5aOnVSCRnB/WiMnRHPXX0IjZsbP7NTRi9chEXqURRPVjNspVGgHU3AbE732iLESZQ+VB
lVtDVHUoGcp+YAtRzaHmrpAZQw9R3aFap15uhKiBcqujjnBFWiaaIlZOKJKWj9Zzv4abm9uz
B/R2nptDlJGdwAk3h6hW461O3m00cxtto2a2qaghytloz1ZDPefdRjO30S5HA+sQ1UOUs9Fu
Rrc6I0Q5G11pdSOozUYzt9H+sVzpqpUKfuHIHMVWKkSJlPAVlt2wCjesYcc13hBVQ5QzrNGO
Q7gQ1UKUM6wxHzvbIPQQhYbV0sesTIgaIQoNq6XShX2rzbAKNayWtKVQOm6zwayhpblWhPYu
uzUItYaWeo23i7Jbg1BraOuAtBNUC1FoDS3P6Cx0ybJbg3BryCqJPasRopw15Foae4ObNQi3
htyPC5sPs3R/hcpfYZnBQ+hmdH+Fyl9hWTMwCKqFKPcKJyhev3R/hcpfYbEWuxndX6HyV1jW
lWOC2l6h8ldYRquhkdr+3I0/d8ktfoW2P3fjz12k5fBh2f7cjT93MY4aIco9d2k1XqENnrvx
5y5zZxRKp+4Pq/KHpbnGYWndH1blD0vFYkHX/WFV/rDUjoOQELU9rMoflq7evhGr7b+wnfiF
45hbHaJGiHK/0HKOd6QNfmHjv9DWtbKI1fev1U98LUsaLoYdvlY/8bXWUUvEGsAa95MLD7D6
SN49/JxcKA8mF9oMmC1cri5KLqxT1XjPeFFyoa0M3LV5V0SZxavVRcmFVtsxhPpXSC60GUHE
6r0oudDWtQeGOj+5sMZ0xU7zouTC6t0nzK5YcgFRdcR74lPJBRBv6/xsIIf2njMKrqceS+ei
REWb+7zMYtPzExWt63E/9VdIVLS162cpgfMTFfOx53jbf1GiYpXuD/aszk9UrGv/xpI65ycq
2movF27OTiQqELV65V2bqAB7H3MVZa9ws/fM7X0Mjc3hoqRHTx+v1vwKSY++Ri6Fir4o6dFn
aBqnaS9KevRUR5wQvSjpMb1Mp/mT85MeU4MSnyCdSHogqki8czmV9PhHYGmO0wsFjLRQI+25
JhrJn59A6bkfBfa/QgKlrwJ+hjo/gdJLHsryC+cnUNb4rsLSOucnUHpZxSpXJlAQ1Xp8GnQq
gQKWVT720YlZOWQ5yzruSP8qyZjVtipeoy9KxnTpNc75XpSM6ZpqCdedi5IxXZc9XJmMQZRa
ZdkmmowBc9CPfQhiVg5Zzhy026+U2OmWLI4oL0rsdCs6Qu9wUWKnm2p8/nkisYOoqo2haGIH
3uF8gy3UjsE7NP4OV9EYy6GcnyTqazBwuO5clCTqVTPN7LAkEaJqHlcnieDB17kghlZa4cFX
/uDXzZ9QPBclnKZ/z/Exx4mEE6BGynHMeirhBE9rlByv+A2eVuNPa6z7ilcmr/An1hTHrKeS
V/gTW4uzBR1+Yj/xE0eL40OfCGPfa77FGodiA77XoN9rzA1zicM6SBh8+ioxrKbh1+qfMnTl
4crIkdbEx18lQzfSqA98gWsydGN1dGLJvvMzdCPL0a/vV8jQjekK4sXhogzdyDNyZo/9/Azd
mDt2WrNzfoZuehV9IMl7TYZuFBGaCjs/QzfKmiB+bYYOWfUYT3Vdhg5ZnZyRLFZo8NkZvCRS
arNYocVnZ/FSLK4FXqzQ5LMzeVERZhE5tPnsbF7m16LvMTT67IxeWqVp6RxafXZWvw7zaAVk
aPbZmf06zaPZ5NDus7N7/djGN/anod0XZ/dqiZcvh3ZfnN1rPToux6zQ7gsWm48Z58TVLYsV
2n3BEvGxZvOwJOn5GfNhhaT9LsqYD5OHDs6uyZgPM+K8LsqYD2s1riO5KGM+bJAa9Isy5nP7
2GkN+vkZ81FLjyuwLsqYj6o9Dr5OZcyRVWscMp3KmCOra5wjyLD+7Cxn8C2RNTbD+rOznMW3
onGgk2H92VnO5OeKYfSEIbR5v/40I/mZDOvPznJG31arCMYKrd6vP613WkecQ7P3609PNS6Q
yLD+7Cxn9yuDS08gQ7v3609XicP7DOvPznJ232009htLaPd+/enNOCu0e7/+9EFydhedYI2R
9eoLJoiS3NlZ0fknWMcJXfiwLjrBGtM/x2v1RSdYM7Zv9Fzt/BOsMVnxLumCE6zx1eqNEqcv
Tp1gIau0Ggrx1AkWsrTFjqvAorGzimNVEmgUWDR2ljhWL3F1XoFFY2cpsnIq8SldgUVjZ5lj
ldzo8wqNHhaNxZLObSK0elg0FsuMCiiHZg+LxmI1jYuYCiwaO8vZfV63wAmrhHZfnN2XnONU
W4FFY2c5uy+lxedrBRaNnbUvGoulLa7UKrBo7Kx90VisWul55Lknygu1cvu/wonyREmyeE9/
wYnyQuWj4dsvPlFeKCEJhAtOlBfKSEnUBSfKC9VIfcGpE2Vk9RYXwZw6UQaWnniHm6ffWc7T
ax6xFxTw9DvLefq1E6TfKzR57+l1dbpgrNDmvafXGbdQVmj03tOvifDMUnNo9d7TW2rxhT4B
T7+znNlbMVp0kkO7957elJR1C3j6jeU9vdUcpxkFPP3Ocna/Uhvs4k4J7d57emM3TwU8/c5y
nr7mFhf6X1DhsVCr8+mvUOGxUJYo6twKj4WqEhvqBRUeC9XIan1BhcdCDYs3vKcqPIA114w4
S3KqwgNZkujT2tzzznLueV2xoCwJWc49t1pLuDIquOed5dxz67nQ6prQ5r177okcUyu4553l
jH4d6lNWaPXePXeR+ChewT3vLGf23XJc56bgnneWs/teW5y1VHDPG8u7595bHFApuOed5ex+
zI0JKykrod179zyKxEefCu55Zzn3PLTELueCiquFmrsSVrx1bsXVQrUeW9cFFVcLNUi0fkHF
1fgqz0g21vWpiitkTRT7WrTiClna4qS/gU/dWehTVz+sOItt4FN3FvrUvJwX/V4astCn5mld
sRYNfOrOQp+acz7BCo3e+dScJcUneQY+dWeh1eesI666MvCpOwvNfsZmIy5hNfCpO8vZfe4t
7kpj4FM3lvOpucwgm7JCu3c+NZdS4uy6gU/dWehTc9ES+1QDn7qz0Kfmwk78L6iAXKhW4yX7
ggrIhVqVeAR1bgXkRM1XGG8uT1VAIqtIXKd7qgISWSqNVmaWkOUc4apRY49rc4SVO0LpOT4M
r+AIK3eEMqrQ52UhyzlCzRbnJCo4wsodoYrGBy4VHGHljlBNaQlxDs3eO8IZI8TpwQqOsHJH
qEPjkpkKjrByR2i5xUeWFRxh5Y7QVm89xgrt3jvCdRObPfsS2r13hDY34+Gzv6AieaH6Q40Q
P6POrUieqNWeOVTQqYpkZBWNC7JOVSQjSzUukmjgvRr3XrVKrMYG3qtx71XXpBnG0pDlvFcd
Iz7vauC9GvdeLVt8taaB92rce7W5DNHf2EKW817NyFWDBt6rce/VGslTNfBejXuvdU2bfa8S
2r33XusuJmWFdu+915rZzX5jCe3ee6/+sRl2zArt3nuvXiV2ORfcEFionvvVNwSANVIqV98Q
QFYmlWcdXE7nLmesWZGMJSHLuZxhpKVLB5fTucsZTeNIqIPL6dzljFHio9kOLqdTl1NSzvFF
0Q4up1OXs4KqxDqxbC6nU5dT0hodw1ih3TuXU1Jt8ca3g8vp1OWsBtRxZq+Dy+nU5ZScJC4j
6OByOnU5pTRyHayDy+nU5ZQZo8Wbr1M3duA3SurxIc6pGzvIKi32OQP8xKB+YoV78X2ZAX5i
UD9RpFrsogf4iUH9xJp0yJ+XhSz0E0VTibNoA/zE4H5CS4p94QA/MbifUCG9aAb4icH9hM5d
NLXVEbKcn9BGbisN8BOD+4kZpFENldDuvZ+wXOK2KAP8xOB+wiTHPQYG+InB/cQK0uK6ZX+D
jorbaie9X+BGT2Y3ehaskzZ/Ga70ZHalZ8JmpBYfDGW405PZnZ4FK6r8Z1oIcwKvKqQbL9zq
yexWz4JVsjvMcK0ns2s9C9YTuQEA93oyu9czYTP6IJ2C4WJPZhd7Fmxugynsvsozu9mzYNLi
NFiGqz2ZXe1ZMLPY9We425PZ3Z4FaxonNDNc7snscs+CDYkzThluO2R222HCes5kWgZcd8js
usOCSSJXJ+C+Q2b3HRZMR9yaLsOFh8wuPCxYbeRmDtx4yOzGw4KxvFOGKw+ZXXmYsLm7I/4M
7jxkdudhweg9Bbj0kNmlhwVTUpie4dZDZrceFqySK/8Zrj1kdu1hwXqKG+pnuPeQ2b2HBRuk
CC/DxYfMLj6Mr2S1W4iNFgrBMy8El1WaGcsJKsEzrwSXZKSyOUMpeOal4KvHZ7xfz1ALnnkt
uKRB6sozFINnXgwuObOlDqrBM68Gn26WzErKUA6eeTn43OmR+oUM9eCZ14NLrjUuFchQEJ55
QbhkFkVnqAjPvCJc1nVRDgsV4OVUCmmamqFCNvMKWSma4/LrDCWymZfISrFB1k2okc28RnZG
0qSxfYYi2cyLZGW62vjUOkOVbOZVsrLmYcbahDLZzMtkRUTjbGCGOtnM62RFrJArjFAom3mh
7OrSTfwZVMpmXikrMkjrlwylspmXyq4nRgZIQeFg5oWDoqWRK35QOZh55aDMHS1RAJQOZl46
KFotTiZlqB3MvHZQtAvZUkHxYObFg2KpxAU4GaoHM68enDbLZnhB+WDm5YNiwlwQ1A9mXj8o
Zp3sz6CAMPMCwrltqWQbCtVUmVdTiQ3SVzpDOVXm5VQyd6FkdYJ6qszrqVbr7Li0JENBVeYF
VVJtrukMttkZr6iS2hKJnaCkKvOSKqmd9InMUFOVeU2VtFWhTWESwpydtVJJHAAFJpkXmEhT
I/szqDDJvMJEVmP12DSgxCTzEhNpvZC3CTUmmdeYyCoej18AFJlkXmSyLnGSnCNUmWReZSJd
GtEmlJlkXmYi3VhXDzhxz/zEXXojlx0yHLlnfuQufZAzhQxn7pmfucvIpFQ7w6F75ofuMlb0
RGElhLm3OXSQPt1w7J75sbuM2klmDw4gMz+AlBnvkxcAJ5CZn0BqSuS0KcMRZOZHkOuEiLRE
gTPIzM8gNbFRSxkOITM/hNRUM0mSwGlM5qcxmljxUIbjmMyPY+b+uJM9LZzHZH4eMwNEclMk
w4FM5gcymsXiUuQC6ejC09E647D4pKhAOrrwdLSuwY/8m0kI8z9zNfcPYZCMKzwZpyWnOH9W
IBlXeDJOS+nxKWmBVETZpi4/ADN5oPb3p56S9aGekutTa/5I9BUu6Cm5UJ0Ebxf0lJwo+Tjh
PESd21NyoYrFVzkv6Cm5UKq0Mdu5PSUXas27Jqhze0ouVC90eOu5PSUnai4WsUO4oKfkQmVS
M3lBT8mFkh57lkt6Si6WNdrD7uyekovValwLdUlPycUaFvc4uKSn5GStyc60D+S5PSUXS8jN
l0t6Si6WlTi7dklPycVq5HLCJT0lF6sP2pT17J6Sk1UTH8p8dk/JxSotXh0u6Sm5WEo6NF/S
U3Kxao3P10/1lERWN+q8aE9JYLXVRoOxQrsvzu5bkbg2cbFCuy/O7puSWrvFCu2+OLtvNWfK
Cu2+OLtvndytWqzQ7ouz+zYGn/gW2n1xdt8zOQpfi39o9+LsfkZlcfnGYoV2L87uu1ncRGOx
QrsXZ/e9kTkIixXavTi7n/F6HPosVmj34ux+huvxPJLFCu1enN2PdTbDWKHdi7P7YSk+Tlys
0O7F2f1qfU5Zod2Ls/vRe9wEaLFCuxe0+9USN07kr51qaPeKdm+p1PhYbLFCu1e0++mgSd/F
xQrtXtHuLbH5H4sV2r2i3U+LIPXQixXavaLd24zqaLt4De1e0e4tF5IoX6zQ7hXtfm7lEm3N
rqHdK9r93GAOqkcN7V7R7o97gGx91NDu1dn9uuzAnpeFdm/O7uejpzM+LbR7c3ZfxGh/cAvt
3pzdFyNXfBYrtHtzdl9mCENZod2bs/tVkMU0ZKHdm7N7yZk/r9Duzdn9DDtoj30L7d6c3YuO
uM3hYoV2b87u13aC2b2Fdm/O7qWTQ8iVAwjtvjq7V3Y9dLFCu6/O7rUoDd1raPcV02UrJ0j3
TDW0+4oJLtMqpDrj/J7xC9XJbccLesZP1Fy2487/F/SMX6g84lvfF/SMXyjppJTo/J7xC8Ua
Q1zQM36hGpuhc37P+IUapOvyBT3jJ6pmcu34kp7xiyWsJBXyS6xn/GT1lEgtBuSXeBW19Tzi
PM4lPeMXix6DQn6J11CvlpDx+nNJz/jFaqShwCU94xdrGClhh/wSL6C2kVlVGeSXeP20DSEH
I5f0jF8sI62XL+kZv1iNj2I+u2f8YvVB++LTnvE7q65aAvYeac94ZBUSn2XIL+0stPua5hLL
Vo0S2r3LL9U0UczuS2j3Lr9UZ5RN9VhCu3f5pbrahdHfGNq9yy/VXAqdXl1Cu3f5pZo1Uz1K
aPcuv1RzZXVMkF/aWWj3NbdBn5eEdu/yS2vYY7x/zpBf2lnO7ueTJ0VMkF/aWc7uZ0xFB9BI
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
IDtHKEsxXpZSpLJ4Ew7ljR/KF+lktofBobzxQ/n59AuJ6uBQ3vih/IyDRzxFyeBQ3vihfFFp
JESEQ3njh/JFjYxkMjiUN34oP3d65BqEwZGk8SPJooP0dTc4kjR+JFmMpgnhSNL4kWSxQvq6
GxxJGj+SLDbfQPw24UjS+JHk3ANJfMBscCBj/EBmOloyytDgQMb4gUyxuXWM1004kDF+IFNq
ZusmHMgYP5Ap0wHF99ErpKMrT0eXauQmVoV0dOXp6FIbae9QIR1deTq61E7aO1RIxlWejCst
kZtYFZJxlSfjSpseLf5mkIr49F1imOIA1M//leF5/bO7V29e3r6/vflt0TKOv/bdlzfpoH94
e/vuLz9/ttWVzP/9P/zum5u3L+6evL39/sW797dvn7x79vT1zXd3b29evbl7+/7Ji+ePH+XP
n5o2P1e3v/n73/8ff/t/3vzF+uCzV39x8+rpf58feP3h1be3b29mdHbz/d3tu5tvb1/e/fnm
/R9vb57/+PrpqxfPbp6+fHn37On7F3ev55d+/f3tz9ye2+pj9P37N9/c/Kd/+sebV3fPP7y8
vXl59/T57fOb3755/ubm2ft/v3n34j9ub3q6+fbH9/d/S5ePqez3zx6tX/zzf/gqfXPz7vb9
+xevv7959+P8da9uns0v8MPN+7ubknJ7lPRRyfM/flPKN/Nx/fM//c3Nb/OaSD9DHB33/oJa
jsvyz189ffL232+/+fTFPv/3TVZt/V/9lz/81c3z2z+9eDa/+nya33z+A/0oCb25+W93N+/u
Prx+/uzp2+fv5mOe//Grn//U0LJiob97e3u7vvKH1x/ezV//w+3b17cvb17dvrp7++M3N5JH
+WwdayTNlOf/9fbFfOlv3t69v312/Nz11D998O3t0+eP7l6//PHm+dP3TydAe64/fCaMtJwi
/0vzdOk//6XriHbVPvOPqNWfP9GbliWvb1/+8OTDm/k1bqe9/duHw2T/4evf3dy+fXv39sv1
6G6+ez7dwLv5K6ZBpc+ft74qh797effmzWQff/7mkd38+Y8vppmsX7i+yLfHy/35UyNpWQne
a//WkebfWi77W/WrtFJX+dq/dX2+lpUTuvRvXUmuf/30r19/+zzrNzd/9X6a/Jv38928u339
/Gaq7sXrPz19+WL+8/xTt+9//vBIeTVqOeMrH+Sfv3T5TMh1beH+9v/+J3303bub3x5/bjq5
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
L+68s4f+cY7Oz1bZrnpxi6IPU859cQthDyOufXEL2U4jT7y4SakXRRFdjxkXZ7+4dqxx93zl
ebvRNSn9vlle5ysXpT1MOfvNrZHtDyOufnPt6EhyCnnqzTVZqfkL3lwTK+e/uZEO13rvzZ13
5DA/1+9pbly3q1kUeZhy7ptbCHsYce2bW8h6GnnizY10b3d5zptbw6zPd5aS8thTLme9uHX5
7X7KZVyVcjko8jDlzBd3IPRhxJUv7kDW00j+4iblOBg++8XNDxytb85+cXM72i/djkoy0f11
n5WpmZ/T+0HxuGpxXJT7e6Nx+eJ4IMrDiKvft+n9jVKEPPW+7RiNc8H7Nuv9/Pe9Tgq37eh5
R27r1ub9VM24aj96UOrDlHPf3EK0hxHXvrmF7KeRJ95cWYdCl7y5Ui7Z1ojosTheqNT5obUL
/Py+zzo0mh/L6fNTzin1q973wvQAc+4Ln4ycAsa1b3wx8xnME69c5Yiuz3/l8wMX5MOlzrd3
cVMOGXOpb5d+SouqXfx3qa1HcPGn+sd+7Jd9yrK2y3/X9KZFL2ynMj/V9LgEetmnarJjDtCF
n5pWIRf/rrqacF/8vmq140zwTAOsQ49Clsv+kj7EFKu2zsp69GHqap8vqWjtowne+juvMrWP
kfFg/rwvPVIaBUtQz/xkaQmvXVzyc+euvuV6zc8dqZrYdZ/sR2ri3GKK0zW8I+ej/urenuS8
x5fluCP6c1B71W5y5Gms7WHKmUvUWA3Zy8OIK1eoUVLecgBX7SbHqkS7JOwbpZ6fI7O5+Zzh
2+fdxbvnT/9y9WX78PL56//l/c13L14/v3n94uW0r7vXH3ujHf3Cfv50LVXux22/dGFfyGkR
5TTywcdWys+YXo95r2c+BrVxjDr9+MffPH3/xycv7+5++PBm/e63U0LzCby9ff/h7evb5z+9
hfLFf/7YQ+zoW/fNzV8vpf3uPx+/JJd6BGbHnJdnHx5NK54fvv1mNXv75ua7T/+v61TNs2fp
5k9LfPnm/Xcv5x9J8w89Xf84/893H//x0/959e2n//rn//vDT//h7U//4dMf/Xb9n9fvF+bu
9d13699+nb6Z///mUf4yfbP+183855vf/v3/83hunv7y5tunb9++WF/j+HM3z76dK8bd8/n5
zz+nt2Pc2/2f8/tph7dvb/7xxZv5Dzdl/p3uf37+fE5H6umhz//10/fP/jgB6SHEZ0Du61hv
A6yubo/++jCnv3kx/5uXR7++AxV9l1q+anNVXKh/fv1TI8GbN3+6effHp2/n6/3YEu5oKvjs
zYf7H6p1lc9vf/8/v3737I+3q/3f85+a9r3744f3z+/+/HpqZfW3+9h4L9c1bLzl9be+e74e
/fE/N/8yFfevN3/48fWzP769e/3iP5ao//A3f/iHm2dPJ/fzJ5eDmn/17XLn67FNm397r1Pg
z38wJzumhHz6g68m5cXrtc4fH/jii799+fTNan/3/sWr+e1zS1988cOfXj3+7Re/+bfbVx8e
faQ9+vden1T94jePbg8P/mj+kfkP62n8/dN3f759+fLL/+3dq9s3638/fTP/m0/N9L5+88P3
X7988frDv3/9kfDo7dPXz5/dvf7uxfePnqZHUxAzENDx9ffPnj2am8ivv/32+TSq+T/27HYN
PH/6rJXn1uy7diuaRL61p/ZdLenrP71a2P+YH8r5q/To7bP6KK00yaPvPyHml3jx+sX7t89v
vr579+LV0+9vv/7xbi4eH//3o/dv13/746cf9tWz7/9jfuDVjeUy/++7V2+mmf/m0adeiLdT
D+nL17fvj/Xv9n2a/9XHf7r58O727Zcvnv/0b4+19e7ttODHr5+tP3X36OODn//5z8ukn999
f/OiTh97++7be//u0dNnR1fJ57fffvh+/vvpFKb+3t0+nnb89OV6NevbvH3xp+kdp3N8/PV3
775+9/y7/PXqyZkeffxJf3rzqH756vb5i6eP17/+8sV3j//0YtrEHfls/gWfLb/gs/ILPqu/
4LP2Cz5bz/jsmxfP1wdvvp7G8fW7P776+of19r+e//reh5eF3b598fTl8Zd8A3/285/7+uOf
OvuP//Dq3TKe50+nv5qe47CZF+/evHz641zfXq9/XP/+/dHq9OXLL/7yiy+evnlz+/r5Evta
0h4f6LdPX01T/uOH198/ef/03Q9P3jx9/eLZ4ymHT8b59M38x0//eXqHt//25OnLPz/98d2T
j67h+WQ9+9is7av5H55MH/Fkupq5Ti8zvvvwfq0uX/xmCuarF9+9fvrq9t3j+Y9vphzf//DV
/PvXj3h893r+q+PvfTT/4rkrfb8c+oc3n7/M61cvnvyknsfHv/3iN3d3b9799J9Xh9Mn86es
N/S4rL/g7tWb9z//m/lXPn/77fOvXr14fff2ybO1EXjcj98zvd3zr17eff/k5e2fbl8+nkv7
F7958f38U7dzA/D98S+/+M3t07cvf/z4nR+/f//jH9KXq3nC+l3Tt727m5YT/tv5T3/6/unj
CXy1Xu3bP8/v+uL1D4/n6/zw4uXzo/Hru6/ffnj96N8+3H64/fn9nnCgh5NdDuv25TfH/370
7s3d+0erTez6M6nr+OZc5/rNty/WPvvRR6b2r7/6ydueS/jp711HAV3kUfvmvvV/O3/Dsz8+
vveVvw6+8he/+evf/e6fnvzDf/2r//S3j/9/XUwesJapn7/4n//HXAn/5X//1//3L24efRTT
zfx3H//Tv/yv819/8f8BnZcpkMiVBAA=

--=_58fa8fe6.KGFv/UXliio9jXxjVQFvebtQ9aGO5BcnYb6+L2i99TruwxkY
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="reproduce-yocto-vp-6:20170422042348:x86_64-randconfig-a0-04211049:4.11.0-rc6-00220-gbbd8797:1"

#!/bin/bash

kernel=$1
initrd=yocto-trinity-x86_64.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd

kvm=(
	qemu-system-x86_64
	-enable-kvm
	-cpu Haswell,+smep,+smap
	-kernel $kernel
	-initrd $initrd
	-m 512
	-smp 1
	-device e1000,netdev=net0
	-netdev user,id=net0
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-watchdog-action debug
	-rtc base=localtime
	-serial stdio
	-display none
	-monitor null
)

append=(
	root=/dev/ram0
	hung_task_panic=1
	debug
	apic=debug
	sysrq_always_enabled
	rcupdate.rcu_cpu_stall_timeout=100
	net.ifnames=0
	printk.devkmsg=on
	panic=-1
	softlockup_panic=1
	nmi_watchdog=panic
	oops=panic
	load_ramdisk=2
	prompt_ramdisk=0
	drbd.minor_count=8
	systemd.log_level=err
	ignore_loglevel
	earlyprintk=ttyS0,115200
	console=ttyS0,115200
	console=tty0
	vga=normal
	rw
	drbd.minor_count=8
)

"${kvm[@]}" -append "${append[*]}"

--=_58fa8fe6.KGFv/UXliio9jXxjVQFvebtQ9aGO5BcnYb6+L2i99TruwxkY
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="config-4.11.0-rc6-00220-gbbd8797"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 4.11.0-rc6 Kernel Configuration
#
CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_MMU=y
CONFIG_ARCH_MMAP_RND_BITS_MIN=28
CONFIG_ARCH_MMAP_RND_BITS_MAX=32
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_64_SMP=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_PGTABLE_LEVELS=4
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
CONFIG_KERNEL_LZO=y
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_FHANDLE=y
# CONFIG_USELIB is not set
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
# CONFIG_NO_HZ_FULL_ALL is not set
CONFIG_NO_HZ_FULL_SYSIDLE=y
CONFIG_NO_HZ_FULL_SYSIDLE_SMALL=8
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_IRQ_TIME_ACCOUNTING=y
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_RCU_EXPERT is not set
CONFIG_SRCU=y
CONFIG_TASKS_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_CONTEXT_TRACKING=y
# CONFIG_CONTEXT_TRACKING_FORCE is not set
CONFIG_TREE_RCU_TRACE=y
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
# CONFIG_RCU_NOCB_CPU_ZERO is not set
CONFIG_RCU_NOCB_CPU_ALL=y
CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_CGROUPS=y
# CONFIG_MEMCG is not set
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
CONFIG_CGROUP_SCHED=y
# CONFIG_FAIR_GROUP_SCHED is not set
CONFIG_RT_GROUP_SCHED=y
# CONFIG_CGROUP_PIDS is not set
CONFIG_CGROUP_RDMA=y
CONFIG_CGROUP_FREEZER=y
# CONFIG_CPUSETS is not set
CONFIG_CGROUP_DEVICE=y
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_BPF=y
CONFIG_CGROUP_DEBUG=y
CONFIG_SOCK_CGROUP_DATA=y
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
CONFIG_USER_NS=y
CONFIG_PID_NS=y
# CONFIG_NET_NS is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_INITRAMFS_COMPRESSION=".gz"
# CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BPF=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
CONFIG_MULTIUSER=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_POSIX_TIMERS=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_ABSOLUTE_PERCPU=y
CONFIG_KALLSYMS_BASE_RELATIVE=y
CONFIG_PRINTK=y
CONFIG_PRINTK_NMI=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_BPF_SYSCALL=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_ADVISE_SYSCALLS=y
CONFIG_USERFAULTFD=y
CONFIG_PCI_QUIRKS=y
CONFIG_MEMBARRIER=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y
# CONFIG_PC104 is not set

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
CONFIG_SLAB_FREELIST_RANDOM=y
CONFIG_SLUB_CPU_PARTIAL=y
# CONFIG_SYSTEM_DATA_VERIFICATION is not set
CONFIG_PROFILING=y
CONFIG_KEXEC_CORE=y
CONFIG_OPROFILE=y
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
# CONFIG_STATIC_KEYS_SELFTEST is not set
# CONFIG_UPROBES is not set
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_NMI=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_HAS_SET_MEMORY=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_GCC_PLUGINS=y
# CONFIG_GCC_PLUGINS is not set
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=y
CONFIG_HAVE_ARCH_HUGE_VMAP=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=28
CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS=y
CONFIG_ARCH_MMAP_RND_COMPAT_BITS=8
CONFIG_HAVE_COPY_THREAD_TLS=y
CONFIG_HAVE_STACK_VALIDATION=y
# CONFIG_HAVE_ARCH_HASH is not set
# CONFIG_ISA_BUS_API is not set
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y
# CONFIG_CPU_NO_EFFICIENT_FFS is not set
CONFIG_HAVE_ARCH_VMAP_STACK=y
# CONFIG_VMAP_STACK is not set
# CONFIG_ARCH_OPTIONAL_KERNEL_RWX is not set
# CONFIG_ARCH_OPTIONAL_KERNEL_RWX_DEFAULT is not set
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_MODULES_TREE_LOOKUP=y
CONFIG_BLOCK=y
CONFIG_BLK_SCSI_REQUEST=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_DEV_ZONED is not set
CONFIG_BLK_DEV_THROTTLING=y
CONFIG_BLK_CMDLINE_PARSER=y
CONFIG_BLK_WBT=y
# CONFIG_BLK_WBT_SQ is not set
# CONFIG_BLK_WBT_MQ is not set
CONFIG_BLK_DEBUG_FS=y
# CONFIG_BLK_SED_OPAL is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_BLOCK_COMPAT=y
CONFIG_BLK_MQ_PCI=y
CONFIG_BLK_MQ_VIRTIO=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
CONFIG_MQ_IOSCHED_DEADLINE=y
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_LOCK_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
CONFIG_QUEUED_RWLOCKS=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_FAST_FEATURE_TESTS=y
# CONFIG_X86_X2APIC is not set
CONFIG_X86_MPPARSE=y
# CONFIG_GOLDFISH is not set
# CONFIG_INTEL_RDT_A is not set
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_VSMP=y
# CONFIG_X86_GOLDFISH is not set
CONFIG_X86_INTEL_MID=y
CONFIG_X86_INTEL_LPSS=y
# CONFIG_X86_AMD_PLATFORM_DEVICE is not set
CONFIG_IOSF_MBI=y
# CONFIG_IOSF_MBI_DEBUG is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_DEBUG=y
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=12
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_APB_TIMER=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
# CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=64
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_SCHED_MC_PRIO=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=y
CONFIG_PERF_EVENTS_INTEL_RAPL=y
CONFIG_PERF_EVENTS_INTEL_CSTATE=y
# CONFIG_PERF_EVENTS_AMD_POWER is not set
# CONFIG_VM86 is not set
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_X86_VSYSCALL_EMULATION=y
CONFIG_I8K=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_X86_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
# CONFIG_ARCH_MEMORY_PROBE is not set
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
# CONFIG_SPARSEMEM_VMEMMAP is not set
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_MEMORY_BALLOON=y
# CONFIG_COMPACTION is not set
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CLEANCACHE=y
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_CMA_DEBUGFS is not set
CONFIG_CMA_AREAS=7
# CONFIG_ZPOOL is not set
CONFIG_ZBUD=y
# CONFIG_ZSMALLOC is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_ARCH_SUPPORTS_DEFERRED_STRUCT_PAGE_INIT=y
CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
CONFIG_IDLE_PAGE_TRACKING=y
CONFIG_FRAME_VECTOR=y
CONFIG_ARCH_USES_HIGH_VMA_FLAGS=y
CONFIG_ARCH_HAS_PKEYS=y
CONFIG_X86_PMEM_LEGACY_DEVICE=y
CONFIG_X86_PMEM_LEGACY=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_X86_INTEL_MPX is not set
CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS=y
CONFIG_EFI=y
# CONFIG_EFI_STUB is not set
CONFIG_SECCOMP=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_KEXEC_FILE=y
# CONFIG_KEXEC_VERIFY_SIG is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
CONFIG_COMPAT_VDSO=y
# CONFIG_LEGACY_VSYSCALL_NATIVE is not set
CONFIG_LEGACY_VSYSCALL_EMULATE=y
# CONFIG_LEGACY_VSYSCALL_NONE is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_MODIFY_LDT_SYSCALL=y
CONFIG_HAVE_LIVEPATCH=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
CONFIG_ACPI_DEBUGGER=y
# CONFIG_ACPI_DEBUGGER_USER is not set
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS_POWER=y
# CONFIG_ACPI_REV_OVERRIDE_POSSIBLE is not set
CONFIG_ACPI_EC_DEBUGFS=y
# CONFIG_ACPI_AC is not set
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_CPPC_LIB=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_HOTPLUG_IOAPIC=y
# CONFIG_ACPI_SBS is not set
CONFIG_ACPI_HED=y
CONFIG_ACPI_CUSTOM_METHOD=y
# CONFIG_ACPI_BGRT is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
# CONFIG_ACPI_NFIT is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
# CONFIG_ACPI_APEI is not set
# CONFIG_DPTF_POWER is not set
# CONFIG_PMIC_OPREGION is not set
# CONFIG_ACPI_CONFIGFS is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_ATTR_SET=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
# CONFIG_CPU_FREQ_GOV_SCHEDUTIL is not set

#
# CPU frequency scaling drivers
#
# CONFIG_CPUFREQ_DT is not set
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=y
# CONFIG_X86_ACPI_CPUFREQ_CPB is not set
CONFIG_X86_SFI_CPUFREQ=y
CONFIG_X86_POWERNOW_K8=y
CONFIG_X86_SPEEDSTEP_CENTRINO=y
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_PCI_BUS_ADDR_T_64BIT=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
# CONFIG_PCI_STUB is not set
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
# CONFIG_PCI_PASID is not set
CONFIG_PCI_LABEL=y
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y

#
# DesignWare PCI Core Support
#

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
CONFIG_RAPIDIO_DMA_ENGINE=y
CONFIG_RAPIDIO_DEBUG=y
CONFIG_RAPIDIO_ENUM_BASIC=y
CONFIG_RAPIDIO_CHMAN=y
CONFIG_RAPIDIO_MPORT_CDEV=y

#
# RapidIO Switch drivers
#
CONFIG_RAPIDIO_TSI57X=y
CONFIG_RAPIDIO_CPS_XX=y
CONFIG_RAPIDIO_TSI568=y
CONFIG_RAPIDIO_CPS_GEN2=y
CONFIG_RAPIDIO_RXS_GEN3=y
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ELFCORE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
CONFIG_X86_X32=y
CONFIG_COMPAT_32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y
CONFIG_NET_INGRESS=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_OFFLOAD=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
CONFIG_SMC=y
CONFIG_SMC_DIAG=y
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
# CONFIG_IP_MULTIPLE_TABLES is not set
# CONFIG_IP_ROUTE_MULTIPATH is not set
# CONFIG_IP_ROUTE_VERBOSE is not set
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=y
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=y
CONFIG_SYN_COOKIES=y
CONFIG_NET_UDP_TUNNEL=y
CONFIG_NET_FOU=y
# CONFIG_NET_FOU_IP_TUNNELS is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_INET_UDP_DIAG=y
CONFIG_INET_RAW_DIAG=y
# CONFIG_INET_DIAG_DESTROY is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
# CONFIG_TCP_CONG_CUBIC is not set
CONFIG_TCP_CONG_WESTWOOD=y
CONFIG_TCP_CONG_HTCP=y
CONFIG_TCP_CONG_HSTCP=y
# CONFIG_TCP_CONG_HYBLA is not set
CONFIG_TCP_CONG_VEGAS=y
# CONFIG_TCP_CONG_NV is not set
CONFIG_TCP_CONG_SCALABLE=y
CONFIG_TCP_CONG_LP=y
# CONFIG_TCP_CONG_VENO is not set
CONFIG_TCP_CONG_YEAH=y
# CONFIG_TCP_CONG_ILLINOIS is not set
# CONFIG_TCP_CONG_DCTCP is not set
CONFIG_TCP_CONG_CDG=y
CONFIG_TCP_CONG_BBR=y
CONFIG_DEFAULT_BIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_CDG is not set
# CONFIG_DEFAULT_BBR is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="bic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
# CONFIG_INET6_AH is not set
CONFIG_INET6_ESP=y
CONFIG_INET6_ESP_OFFLOAD=y
# CONFIG_INET6_IPCOMP is not set
CONFIG_IPV6_MIP6=y
CONFIG_IPV6_ILA=y
# CONFIG_INET6_XFRM_TUNNEL is not set
CONFIG_INET6_TUNNEL=y
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=y
CONFIG_IPV6_VTI=y
CONFIG_IPV6_SIT=y
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
CONFIG_IPV6_FOU=y
# CONFIG_IPV6_FOU_TUNNEL is not set
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_IPV6_MROUTE=y
# CONFIG_IPV6_MROUTE_MULTIPLE_TABLES is not set
CONFIG_IPV6_PIMSM_V2=y
# CONFIG_IPV6_SEG6_LWTUNNEL is not set
CONFIG_IPV6_SEG6_HMAC=y
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NET_PTP_CLASSIFY=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
CONFIG_NETFILTER_ADVANCED=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_INGRESS=y
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_ACCT=y
CONFIG_NETFILTER_NETLINK_QUEUE=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_LOG_COMMON=y
CONFIG_NF_LOG_NETDEV=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_PROCFS=y
# CONFIG_NF_CONNTRACK_EVENTS is not set
CONFIG_NF_CONNTRACK_TIMEOUT=y
CONFIG_NF_CONNTRACK_TIMESTAMP=y
CONFIG_NF_CONNTRACK_LABELS=y
CONFIG_NF_CT_PROTO_DCCP=y
CONFIG_NF_CT_PROTO_GRE=y
# CONFIG_NF_CT_PROTO_SCTP is not set
CONFIG_NF_CT_PROTO_UDPLITE=y
CONFIG_NF_CONNTRACK_AMANDA=y
# CONFIG_NF_CONNTRACK_FTP is not set
CONFIG_NF_CONNTRACK_H323=y
# CONFIG_NF_CONNTRACK_IRC is not set
CONFIG_NF_CONNTRACK_BROADCAST=y
CONFIG_NF_CONNTRACK_NETBIOS_NS=y
CONFIG_NF_CONNTRACK_SNMP=y
CONFIG_NF_CONNTRACK_PPTP=y
CONFIG_NF_CONNTRACK_SANE=y
# CONFIG_NF_CONNTRACK_SIP is not set
CONFIG_NF_CONNTRACK_TFTP=y
# CONFIG_NF_CT_NETLINK is not set
CONFIG_NF_CT_NETLINK_TIMEOUT=y
# CONFIG_NF_TABLES is not set
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=y
CONFIG_NETFILTER_XT_CONNMARK=y
# CONFIG_NETFILTER_XT_SET is not set

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_AUDIT=y
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=y
CONFIG_NETFILTER_XT_TARGET_CONNMARK=y
CONFIG_NETFILTER_XT_TARGET_HMARK=y
# CONFIG_NETFILTER_XT_TARGET_IDLETIMER is not set
CONFIG_NETFILTER_XT_TARGET_LED=y
CONFIG_NETFILTER_XT_TARGET_LOG=y
CONFIG_NETFILTER_XT_TARGET_MARK=y
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=y
CONFIG_NETFILTER_XT_TARGET_RATEEST=y
# CONFIG_NETFILTER_XT_TARGET_TEE is not set
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=y
CONFIG_NETFILTER_XT_MATCH_BPF=y
CONFIG_NETFILTER_XT_MATCH_CGROUP=y
# CONFIG_NETFILTER_XT_MATCH_CLUSTER is not set
CONFIG_NETFILTER_XT_MATCH_COMMENT=y
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=y
CONFIG_NETFILTER_XT_MATCH_CONNLABEL=y
# CONFIG_NETFILTER_XT_MATCH_CONNLIMIT is not set
CONFIG_NETFILTER_XT_MATCH_CONNMARK=y
# CONFIG_NETFILTER_XT_MATCH_CONNTRACK is not set
# CONFIG_NETFILTER_XT_MATCH_CPU is not set
CONFIG_NETFILTER_XT_MATCH_DCCP=y
# CONFIG_NETFILTER_XT_MATCH_DEVGROUP is not set
CONFIG_NETFILTER_XT_MATCH_DSCP=y
# CONFIG_NETFILTER_XT_MATCH_ECN is not set
CONFIG_NETFILTER_XT_MATCH_ESP=y
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set
CONFIG_NETFILTER_XT_MATCH_HELPER=y
# CONFIG_NETFILTER_XT_MATCH_HL is not set
CONFIG_NETFILTER_XT_MATCH_IPCOMP=y
CONFIG_NETFILTER_XT_MATCH_IPRANGE=y
# CONFIG_NETFILTER_XT_MATCH_L2TP is not set
# CONFIG_NETFILTER_XT_MATCH_LENGTH is not set
CONFIG_NETFILTER_XT_MATCH_LIMIT=y
CONFIG_NETFILTER_XT_MATCH_MAC=y
CONFIG_NETFILTER_XT_MATCH_MARK=y
# CONFIG_NETFILTER_XT_MATCH_MULTIPORT is not set
CONFIG_NETFILTER_XT_MATCH_NFACCT=y
# CONFIG_NETFILTER_XT_MATCH_OSF is not set
# CONFIG_NETFILTER_XT_MATCH_OWNER is not set
CONFIG_NETFILTER_XT_MATCH_POLICY=y
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=y
CONFIG_NETFILTER_XT_MATCH_QUOTA=y
CONFIG_NETFILTER_XT_MATCH_RATEEST=y
# CONFIG_NETFILTER_XT_MATCH_REALM is not set
CONFIG_NETFILTER_XT_MATCH_RECENT=y
CONFIG_NETFILTER_XT_MATCH_SCTP=y
CONFIG_NETFILTER_XT_MATCH_STATE=y
CONFIG_NETFILTER_XT_MATCH_STATISTIC=y
CONFIG_NETFILTER_XT_MATCH_STRING=y
CONFIG_NETFILTER_XT_MATCH_TCPMSS=y
CONFIG_NETFILTER_XT_MATCH_TIME=y
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
CONFIG_IP_SET=y
CONFIG_IP_SET_MAX=256
# CONFIG_IP_SET_BITMAP_IP is not set
CONFIG_IP_SET_BITMAP_IPMAC=y
# CONFIG_IP_SET_BITMAP_PORT is not set
CONFIG_IP_SET_HASH_IP=y
# CONFIG_IP_SET_HASH_IPMARK is not set
CONFIG_IP_SET_HASH_IPPORT=y
# CONFIG_IP_SET_HASH_IPPORTIP is not set
# CONFIG_IP_SET_HASH_IPPORTNET is not set
# CONFIG_IP_SET_HASH_IPMAC is not set
CONFIG_IP_SET_HASH_MAC=y
CONFIG_IP_SET_HASH_NETPORTNET=y
# CONFIG_IP_SET_HASH_NET is not set
CONFIG_IP_SET_HASH_NETNET=y
CONFIG_IP_SET_HASH_NETPORT=y
# CONFIG_IP_SET_HASH_NETIFACE is not set
CONFIG_IP_SET_LIST_SET=y
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV4 is not set
# CONFIG_NF_CONNTRACK_IPV4 is not set
CONFIG_NF_SOCKET_IPV4=y
# CONFIG_NF_DUP_IPV4 is not set
CONFIG_NF_LOG_ARP=y
CONFIG_NF_LOG_IPV4=y
CONFIG_NF_REJECT_IPV4=y
# CONFIG_IP_NF_IPTABLES is not set
CONFIG_IP_NF_ARPTABLES=y
CONFIG_IP_NF_ARPFILTER=y
# CONFIG_IP_NF_ARP_MANGLE is not set

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=y
CONFIG_NF_CONNTRACK_IPV6=y
# CONFIG_NF_SOCKET_IPV6 is not set
CONFIG_NF_DUP_IPV6=y
# CONFIG_NF_REJECT_IPV6 is not set
CONFIG_NF_LOG_IPV6=y
# CONFIG_NF_NAT_IPV6 is not set
# CONFIG_IP6_NF_IPTABLES is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE=y
# CONFIG_SCTP_COOKIE_HMAC_MD5 is not set
# CONFIG_SCTP_COOKIE_HMAC_SHA1 is not set
CONFIG_INET_SCTP_DIAG=y
# CONFIG_RDS is not set
CONFIG_TIPC=y
# CONFIG_TIPC_MEDIA_IB is not set
CONFIG_TIPC_MEDIA_UDP=y
CONFIG_ATM=y
# CONFIG_ATM_CLIP is not set
# CONFIG_ATM_LANE is not set
CONFIG_ATM_BR2684=y
CONFIG_ATM_BR2684_IPFILTER=y
CONFIG_L2TP=y
CONFIG_L2TP_DEBUGFS=y
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=y
CONFIG_L2TP_ETH=y
CONFIG_STP=y
CONFIG_GARP=y
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_BRCM=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_NET_DSA_TAG_QCA=y
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_VLAN_8021Q_MVRP is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
# CONFIG_IPDDP is not set
CONFIG_X25=y
CONFIG_LAPB=y
CONFIG_PHONET=y
CONFIG_6LOWPAN=y
# CONFIG_6LOWPAN_DEBUGFS is not set
# CONFIG_6LOWPAN_NHC is not set
CONFIG_IEEE802154=y
CONFIG_IEEE802154_NL802154_EXPERIMENTAL=y
# CONFIG_IEEE802154_SOCKET is not set
CONFIG_IEEE802154_6LOWPAN=y
CONFIG_MAC802154=y
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
CONFIG_BATMAN_ADV_BATMAN_V=y
CONFIG_BATMAN_ADV_BLA=y
CONFIG_BATMAN_ADV_DAT=y
# CONFIG_BATMAN_ADV_NC is not set
# CONFIG_BATMAN_ADV_MCAST is not set
# CONFIG_BATMAN_ADV_DEBUGFS is not set
CONFIG_OPENVSWITCH=y
CONFIG_VSOCKETS=y
# CONFIG_VIRTIO_VSOCKETS is not set
CONFIG_VIRTIO_VSOCKETS_COMMON=y
CONFIG_NETLINK_DIAG=y
CONFIG_MPLS=y
CONFIG_NET_MPLS_GSO=y
CONFIG_MPLS_ROUTING=y
CONFIG_MPLS_IPTUNNEL=y
CONFIG_HSR=y
CONFIG_NET_SWITCHDEV=y
CONFIG_NET_L3_MASTER_DEV=y
# CONFIG_NET_NCSI is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
# CONFIG_CAN_RAW is not set
# CONFIG_CAN_BCM is not set
# CONFIG_CAN_GW is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
CONFIG_CAN_SLCAN=y
CONFIG_CAN_DEV=y
# CONFIG_CAN_CALC_BITTIMING is not set
CONFIG_CAN_LEDS=y
CONFIG_CAN_GRCAN=y
CONFIG_CAN_JANZ_ICAN3=y
CONFIG_CAN_C_CAN=y
CONFIG_CAN_C_CAN_PLATFORM=y
CONFIG_CAN_C_CAN_PCI=y
CONFIG_CAN_CC770=y
# CONFIG_CAN_CC770_ISA is not set
CONFIG_CAN_CC770_PLATFORM=y
# CONFIG_CAN_IFI_CANFD is not set
CONFIG_CAN_M_CAN=y
# CONFIG_CAN_SJA1000 is not set
CONFIG_CAN_SOFTING=y

#
# CAN USB interfaces
#
CONFIG_CAN_EMS_USB=y
CONFIG_CAN_ESD_USB2=y
CONFIG_CAN_GS_USB=y
# CONFIG_CAN_KVASER_USB is not set
# CONFIG_CAN_PEAK_USB is not set
# CONFIG_CAN_8DEV_USB is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
# CONFIG_IRNET is not set
CONFIG_IRCOMM=y
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
# CONFIG_IRDA_FAST_RR is not set
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=y

#
# Dongle support
#
CONFIG_DONGLE=y
CONFIG_ESI_DONGLE=y
CONFIG_ACTISYS_DONGLE=y
CONFIG_TEKRAM_DONGLE=y
CONFIG_TOIM3232_DONGLE=y
CONFIG_LITELINK_DONGLE=y
CONFIG_MA600_DONGLE=y
CONFIG_GIRBIL_DONGLE=y
# CONFIG_MCP2120_DONGLE is not set
CONFIG_OLD_BELKIN_DONGLE=y
CONFIG_ACT200L_DONGLE=y
# CONFIG_KINGSUN_DONGLE is not set
CONFIG_KSDAZZLE_DONGLE=y
CONFIG_KS959_DONGLE=y

#
# FIR device drivers
#
CONFIG_USB_IRDA=y
CONFIG_SIGMATEL_FIR=y
CONFIG_NSC_FIR=y
# CONFIG_WINBOND_FIR is not set
CONFIG_SMC_IRCC_FIR=y
CONFIG_ALI_FIR=y
CONFIG_VLSI_FIR=y
CONFIG_VIA_FIR=y
CONFIG_MCS_FIR=y
# CONFIG_BT is not set
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_IPV6=y
CONFIG_AF_RXRPC_INJECT_LOSS=y
CONFIG_AF_RXRPC_DEBUG=y
# CONFIG_RXKAD is not set
CONFIG_AF_KCM=y
CONFIG_STREAM_PARSER=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_PRIV=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
CONFIG_NET_9P_RDMA=y
CONFIG_NET_9P_DEBUG=y
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=y
CONFIG_CEPH_LIB_PRETTYDEBUG=y
# CONFIG_CEPH_LIB_USE_DNS_RESOLVER is not set
# CONFIG_NFC is not set
# CONFIG_PSAMPLE is not set
CONFIG_NET_IFE=y
CONFIG_LWTUNNEL=y
CONFIG_LWTUNNEL_BPF=y
CONFIG_DST_CACHE=y
CONFIG_GRO_CELLS=y
CONFIG_NET_DEVLINK=y
CONFIG_MAY_USE_DEVLINK=y
CONFIG_HAVE_EBPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER=y
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y
CONFIG_ALLOW_DEV_COREDUMP=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_FENCE_TRACE is not set
CONFIG_DMA_CMA=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=0
CONFIG_CMA_SIZE_SEL_MBYTES=y
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_OF_PARTS=y
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
# CONFIG_MTD_BLOCK is not set
CONFIG_MTD_BLOCK_RO=y
# CONFIG_FTL is not set
CONFIG_NFTL=y
# CONFIG_NFTL_RW is not set
# CONFIG_INFTL is not set
# CONFIG_RFD_FTL is not set
# CONFIG_SSFDC is not set
CONFIG_SM_FTL=y
CONFIG_MTD_OOPS=y
# CONFIG_MTD_PARTITIONED_MASTER is not set

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
# CONFIG_MTD_CFI_INTELEXT is not set
CONFIG_MTD_CFI_AMDSTD=y
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_PHYSMAP is not set
CONFIG_MTD_PHYSMAP_OF=y
CONFIG_MTD_PHYSMAP_OF_VERSATILE=y
CONFIG_MTD_PHYSMAP_OF_GEMINI=y
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=y
CONFIG_MTD_ESB2ROM=y
# CONFIG_MTD_CK804XROM is not set
CONFIG_MTD_SCB2_FLASH=y
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=y

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=y
CONFIG_MTD_PMC551_BUGFIX=y
CONFIG_MTD_PMC551_DEBUG=y
# CONFIG_MTD_SLRAM is not set
CONFIG_MTD_PHRAM=y
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTD_BLOCK2MTD=y

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_NAND_ECC=y
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=y
CONFIG_MTD_NAND_BCH=y
CONFIG_MTD_NAND_ECC_BCH=y
# CONFIG_MTD_SM_COMMON is not set
# CONFIG_MTD_NAND_DENALI_PCI is not set
# CONFIG_MTD_NAND_DENALI_DT is not set
CONFIG_MTD_NAND_GPIO=y
# CONFIG_MTD_NAND_OMAP_BCH_BUILD is not set
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=y
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
CONFIG_MTD_NAND_DOCG4=y
CONFIG_MTD_NAND_CAFE=y
CONFIG_MTD_NAND_NANDSIM=y
CONFIG_MTD_NAND_PLATFORM=y
# CONFIG_MTD_NAND_HISI504 is not set
CONFIG_MTD_NAND_MTK=y
CONFIG_MTD_ONENAND=y
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
# CONFIG_MTD_ONENAND_GENERIC is not set
# CONFIG_MTD_ONENAND_OTP is not set
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR & LPDDR2 PCM memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
CONFIG_MTD_SPI_NOR=y
CONFIG_MTD_MT81xx_NOR=y
CONFIG_MTD_SPI_NOR_USE_4K_SECTORS=y
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
CONFIG_MTD_UBI_GLUEBI=y
# CONFIG_MTD_UBI_BLOCK is not set
CONFIG_OF=y
# CONFIG_OF_UNITTEST is not set
CONFIG_OF_DYNAMIC=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_ADDRESS_PCI=y
CONFIG_OF_IRQ=y
CONFIG_OF_NET=y
CONFIG_OF_MDIO=y
CONFIG_OF_PCI=y
CONFIG_OF_PCI_IRQ=y
# CONFIG_OF_OVERLAY is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
CONFIG_PARPORT_SERIAL=y
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
CONFIG_BLK_DEV_FD=y
# CONFIG_PARIDE is not set
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=y
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
CONFIG_BLK_DEV_NBD=y
CONFIG_BLK_DEV_SKD=y
CONFIG_BLK_DEV_SX8=y
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=y
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
CONFIG_BLK_DEV_RSXX=y
CONFIG_NVME_CORE=y
CONFIG_BLK_DEV_NVME=y
CONFIG_BLK_DEV_NVME_SCSI=y
# CONFIG_NVME_RDMA is not set
# CONFIG_NVME_FC is not set
# CONFIG_NVME_TARGET is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
# CONFIG_AD525X_DPOT is not set
CONFIG_DUMMY_IRQ=y
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
CONFIG_INTEL_MID_PTI=y
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=y
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
CONFIG_DS1682=y
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_SRAM=y
CONFIG_PANEL=y
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
# CONFIG_PANEL_CHANGE_MESSAGE is not set
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
CONFIG_EEPROM_IDT_89HPESX=y
CONFIG_CB710_CORE=y
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
CONFIG_INTEL_MEI=y
# CONFIG_INTEL_MEI_ME is not set
CONFIG_INTEL_MEI_TXE=y
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Bus Driver
#
CONFIG_INTEL_MIC_BUS=y

#
# SCIF Bus Driver
#
# CONFIG_SCIF_BUS is not set

#
# VOP Bus Driver
#
CONFIG_VOP_BUS=y

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#

#
# SCIF Driver
#

#
# Intel MIC Coprocessor State Management (COSM) Drivers
#

#
# VOP Driver
#
CONFIG_VOP=y
CONFIG_VHOST_RING=y
# CONFIG_GENWQE is not set
CONFIG_ECHO=y
# CONFIG_CXL_BASE is not set
# CONFIG_CXL_AFU_DRIVER_OPS is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_MQ_DEFAULT is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
# CONFIG_SCSI_ENCLOSURE is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
CONFIG_ISCSI_BOOT_SYSFS=y
# CONFIG_SCSI_CXGB3_ISCSI is not set
CONFIG_SCSI_CXGB4_ISCSI=y
CONFIG_SCSI_BNX2_ISCSI=y
CONFIG_SCSI_BNX2X_FCOE=y
CONFIG_BE2ISCSI=y
CONFIG_BLK_DEV_3W_XXXX_RAID=y
CONFIG_SCSI_HPSA=y
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
CONFIG_SCSI_ACARD=y
CONFIG_SCSI_AACRAID=y
# CONFIG_SCSI_AIC7XXX is not set
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
# CONFIG_AIC79XX_BUILD_FIRMWARE is not set
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC94XX=y
CONFIG_AIC94XX_DEBUG=y
CONFIG_SCSI_MVSAS=y
CONFIG_SCSI_MVSAS_DEBUG=y
# CONFIG_SCSI_MVSAS_TASKLET is not set
CONFIG_SCSI_MVUMI=y
CONFIG_SCSI_DPT_I2O=y
CONFIG_SCSI_ADVANSYS=y
CONFIG_SCSI_ARCMSR=y
# CONFIG_SCSI_ESAS2R is not set
# CONFIG_MEGARAID_NEWGEN is not set
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=y
# CONFIG_SCSI_MPT3SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
CONFIG_SCSI_SMARTPQI=y
CONFIG_SCSI_UFSHCD=y
CONFIG_SCSI_UFSHCD_PCI=y
# CONFIG_SCSI_UFS_DWC_TC_PCI is not set
# CONFIG_SCSI_UFSHCD_PLATFORM is not set
CONFIG_SCSI_HPTIOP=y
CONFIG_SCSI_BUSLOGIC=y
CONFIG_SCSI_FLASHPOINT=y
CONFIG_VMWARE_PVSCSI=y
CONFIG_HYPERV_STORAGE=y
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
CONFIG_FCOE=y
# CONFIG_FCOE_FNIC is not set
CONFIG_SCSI_SNIC=y
# CONFIG_SCSI_SNIC_DEBUG_FS is not set
CONFIG_SCSI_DMX3191D=y
CONFIG_SCSI_EATA=y
CONFIG_SCSI_EATA_TAGGED_QUEUE=y
# CONFIG_SCSI_EATA_LINKED_COMMANDS is not set
CONFIG_SCSI_EATA_MAX_TAGS=16
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_ISCI is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
CONFIG_SCSI_INIA100=y
CONFIG_SCSI_PPA=y
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_IZIP_EPP16 is not set
# CONFIG_SCSI_IZIP_SLOW_CTR is not set
# CONFIG_SCSI_STEX is not set
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
# CONFIG_SCSI_SYM53C8XX_MMIO is not set
CONFIG_SCSI_QLOGIC_1280=y
CONFIG_SCSI_QLA_FC=y
CONFIG_TCM_QLA2XXX=y
# CONFIG_TCM_QLA2XXX_DEBUG is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
CONFIG_SCSI_DC395x=y
CONFIG_SCSI_AM53C974=y
CONFIG_SCSI_WD719X=y
CONFIG_SCSI_DEBUG=y
# CONFIG_SCSI_PMCRAID is not set
CONFIG_SCSI_PM8001=y
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_VIRTIO=y
# CONFIG_SCSI_CHELSIO_FCOE is not set
# CONFIG_SCSI_DH is not set
CONFIG_SCSI_OSD_INITIATOR=y
# CONFIG_SCSI_OSD_ULD is not set
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
# CONFIG_ATA is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
# CONFIG_MD_AUTODETECT is not set
# CONFIG_MD_LINEAR is not set
# CONFIG_MD_RAID0 is not set
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
CONFIG_MD_CLUSTER=y
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_MQ_DEFAULT is not set
# CONFIG_DM_DEBUG is not set
CONFIG_DM_BUFIO=y
# CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING is not set
CONFIG_DM_BIO_PRISON=y
CONFIG_DM_PERSISTENT_DATA=y
CONFIG_DM_CRYPT=y
# CONFIG_DM_SNAPSHOT is not set
CONFIG_DM_THIN_PROVISIONING=y
CONFIG_DM_CACHE=y
# CONFIG_DM_CACHE_SMQ is not set
CONFIG_DM_CACHE_CLEANER=y
CONFIG_DM_ERA=y
# CONFIG_DM_MIRROR is not set
CONFIG_DM_RAID=y
CONFIG_DM_ZERO=y
CONFIG_DM_MULTIPATH=y
CONFIG_DM_MULTIPATH_QL=y
CONFIG_DM_MULTIPATH_ST=y
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=y
CONFIG_DM_VERITY=y
CONFIG_DM_VERITY_FEC=y
CONFIG_DM_SWITCH=y
# CONFIG_DM_LOG_WRITES is not set
CONFIG_TARGET_CORE=y
CONFIG_TCM_IBLOCK=y
CONFIG_TCM_FILEIO=y
# CONFIG_TCM_PSCSI is not set
# CONFIG_TCM_USER2 is not set
# CONFIG_LOOPBACK_TARGET is not set
# CONFIG_TCM_FC is not set
CONFIG_ISCSI_TARGET=y
# CONFIG_ISCSI_TARGET_CXGB4 is not set
CONFIG_SBP_TARGET=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
# CONFIG_FIREWIRE_SBP2 is not set
CONFIG_FIREWIRE_NET=y
CONFIG_FIREWIRE_NOSY=y
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
CONFIG_BONDING=y
CONFIG_DUMMY=y
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
CONFIG_NET_TEAM=y
CONFIG_NET_TEAM_MODE_BROADCAST=y
CONFIG_NET_TEAM_MODE_ROUNDROBIN=y
CONFIG_NET_TEAM_MODE_RANDOM=y
CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=y
# CONFIG_NET_TEAM_MODE_LOADBALANCE is not set
CONFIG_MACVLAN=y
CONFIG_MACVTAP=y
# CONFIG_IPVLAN is not set
# CONFIG_VXLAN is not set
# CONFIG_GENEVE is not set
CONFIG_GTP=y
# CONFIG_MACSEC is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_RIONET is not set
# CONFIG_TUN is not set
CONFIG_TAP=y
# CONFIG_TUN_VNET_CROSS_LE is not set
CONFIG_VETH=y
CONFIG_VIRTIO_NET=y
# CONFIG_NLMON is not set
CONFIG_SUNGEM_PHY=y
# CONFIG_ARCNET is not set
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=y
CONFIG_ATM_TCP=y
CONFIG_ATM_LANAI=y
# CONFIG_ATM_ENI is not set
CONFIG_ATM_FIRESTREAM=y
CONFIG_ATM_ZATM=y
CONFIG_ATM_ZATM_DEBUG=y
CONFIG_ATM_NICSTAR=y
CONFIG_ATM_NICSTAR_USE_SUNI=y
CONFIG_ATM_NICSTAR_USE_IDT77105=y
CONFIG_ATM_IDT77252=y
CONFIG_ATM_IDT77252_DEBUG=y
# CONFIG_ATM_IDT77252_RCV_ALL is not set
CONFIG_ATM_IDT77252_USE_SUNI=y
CONFIG_ATM_AMBASSADOR=y
# CONFIG_ATM_AMBASSADOR_DEBUG is not set
CONFIG_ATM_HORIZON=y
# CONFIG_ATM_HORIZON_DEBUG is not set
CONFIG_ATM_IA=y
CONFIG_ATM_IA_DEBUG=y
CONFIG_ATM_FORE200E=y
# CONFIG_ATM_FORE200E_USE_TASKLET is not set
CONFIG_ATM_FORE200E_TX_RETRY=16
CONFIG_ATM_FORE200E_DEBUG=0
# CONFIG_ATM_HE is not set
CONFIG_ATM_SOLOS=y

#
# CAIF transport drivers
#

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_BCM_SF2=y
CONFIG_B53=y
# CONFIG_B53_MDIO_DRIVER is not set
# CONFIG_B53_MMAP_DRIVER is not set
CONFIG_B53_SRAB_DRIVER=y
CONFIG_NET_DSA_MV88E6XXX=y
# CONFIG_NET_DSA_MV88E6XXX_GLOBAL2 is not set
CONFIG_NET_DSA_QCA8K=y
CONFIG_ETHERNET=y
CONFIG_MDIO=y
CONFIG_NET_VENDOR_3COM=y
# CONFIG_VORTEX is not set
# CONFIG_TYPHOON is not set
CONFIG_NET_VENDOR_ADAPTEC=y
CONFIG_ADAPTEC_STARFIRE=y
# CONFIG_NET_VENDOR_AGERE is not set
CONFIG_NET_VENDOR_ALACRITECH=y
CONFIG_SLICOSS=y
# CONFIG_NET_VENDOR_ALTEON is not set
# CONFIG_ALTERA_TSE is not set
CONFIG_NET_VENDOR_AMAZON=y
# CONFIG_NET_VENDOR_AMD is not set
CONFIG_NET_VENDOR_AQUANTIA=y
# CONFIG_AQTION is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=y
CONFIG_ATL1=y
CONFIG_ATL1E=y
CONFIG_ATL1C=y
CONFIG_ALX=y
# CONFIG_NET_VENDOR_AURORA is not set
CONFIG_NET_CADENCE=y
# CONFIG_MACB is not set
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_BCMGENET=y
CONFIG_BNX2=y
CONFIG_CNIC=y
# CONFIG_TIGON3 is not set
# CONFIG_BNX2X is not set
CONFIG_SYSTEMPORT=y
# CONFIG_BNXT is not set
# CONFIG_NET_VENDOR_BROCADE is not set
# CONFIG_NET_VENDOR_CAVIUM is not set
CONFIG_NET_VENDOR_CHELSIO=y
CONFIG_CHELSIO_T1=y
CONFIG_CHELSIO_T1_1G=y
# CONFIG_CHELSIO_T3 is not set
CONFIG_CHELSIO_T4=y
# CONFIG_CHELSIO_T4VF is not set
CONFIG_CHELSIO_LIB=y
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
CONFIG_CX_ECAT=y
CONFIG_DNET=y
# CONFIG_NET_VENDOR_DEC is not set
# CONFIG_NET_VENDOR_DLINK is not set
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=y
# CONFIG_BE2NET_HWMON is not set
CONFIG_NET_VENDOR_EZCHIP=y
CONFIG_EZCHIP_NPS_MANAGEMENT_ENET=y
CONFIG_NET_VENDOR_EXAR=y
CONFIG_S2IO=y
# CONFIG_VXGE is not set
# CONFIG_NET_VENDOR_HP is not set
CONFIG_NET_VENDOR_INTEL=y
CONFIG_E100=y
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_E1000E_HWTS=y
CONFIG_IGB=y
# CONFIG_IGB_HWMON is not set
# CONFIG_IGB_DCA is not set
# CONFIG_IGBVF is not set
CONFIG_IXGB=y
CONFIG_IXGBE=y
CONFIG_IXGBE_HWMON=y
CONFIG_IXGBE_DCA=y
# CONFIG_I40E is not set
CONFIG_NET_VENDOR_I825XX=y
CONFIG_JME=y
# CONFIG_NET_VENDOR_MARVELL is not set
CONFIG_NET_VENDOR_MELLANOX=y
CONFIG_MLX4_EN=y
CONFIG_MLX4_CORE=y
CONFIG_MLX4_DEBUG=y
CONFIG_MLX5_CORE=y
# CONFIG_MLX5_CORE_EN is not set
CONFIG_MLXSW_CORE=y
CONFIG_MLXSW_CORE_HWMON=y
# CONFIG_MLXSW_CORE_THERMAL is not set
CONFIG_MLXSW_PCI=y
CONFIG_MLXSW_I2C=y
CONFIG_MLXSW_SWITCHIB=y
CONFIG_MLXSW_SWITCHX2=y
CONFIG_MLXSW_SPECTRUM=y
CONFIG_MLXSW_MINIMAL=y
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8842 is not set
CONFIG_KS8851_MLL=y
CONFIG_KSZ884X_PCI=y
# CONFIG_NET_VENDOR_MYRI is not set
CONFIG_FEALNX=y
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
CONFIG_NS83820=y
# CONFIG_NET_VENDOR_NETRONOME is not set
# CONFIG_NET_VENDOR_8390 is not set
CONFIG_NET_VENDOR_NVIDIA=y
CONFIG_FORCEDETH=y
CONFIG_NET_VENDOR_OKI=y
# CONFIG_ETHOC is not set
# CONFIG_NET_PACKET_ENGINE is not set
# CONFIG_NET_VENDOR_QLOGIC is not set
# CONFIG_NET_VENDOR_QUALCOMM is not set
# CONFIG_NET_VENDOR_REALTEK is not set
CONFIG_NET_VENDOR_RENESAS=y
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
# CONFIG_NET_VENDOR_ROCKER is not set
# CONFIG_NET_VENDOR_SAMSUNG is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SILAN=y
CONFIG_SC92031=y
CONFIG_NET_VENDOR_SIS=y
CONFIG_SIS900=y
CONFIG_SIS190=y
CONFIG_NET_VENDOR_SOLARFLARE=y
# CONFIG_SFC is not set
CONFIG_SFC_FALCON=y
# CONFIG_SFC_FALCON_MTD is not set
CONFIG_NET_VENDOR_SMSC=y
CONFIG_EPIC100=y
# CONFIG_SMSC911X is not set
CONFIG_SMSC9420=y
# CONFIG_NET_VENDOR_STMICRO is not set
CONFIG_NET_VENDOR_SUN=y
CONFIG_HAPPYMEAL=y
CONFIG_SUNGEM=y
CONFIG_CASSINI=y
CONFIG_NIU=y
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
CONFIG_TI_CPSW_ALE=y
CONFIG_TLAN=y
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_NET_VENDOR_WIZNET is not set
CONFIG_FDDI=y
# CONFIG_DEFXX is not set
CONFIG_SKFP=y
# CONFIG_HIPPI is not set
CONFIG_NET_SB1000=y
CONFIG_PHYLIB=y
CONFIG_SWPHY=y
# CONFIG_LED_TRIGGER_PHY is not set

#
# MDIO bus device drivers
#
CONFIG_MDIO_BCM_UNIMAC=y
# CONFIG_MDIO_BITBANG is not set
CONFIG_MDIO_BUS_MUX=y
# CONFIG_MDIO_BUS_MUX_GPIO is not set
CONFIG_MDIO_BUS_MUX_MMIOREG=y
CONFIG_MDIO_CAVIUM=y
CONFIG_MDIO_HISI_FEMAC=y
CONFIG_MDIO_OCTEON=y
CONFIG_MDIO_THUNDER=y

#
# MII PHY device drivers
#
# CONFIG_AMD_PHY is not set
# CONFIG_AQUANTIA_PHY is not set
CONFIG_AT803X_PHY=y
CONFIG_BCM7XXX_PHY=y
CONFIG_BCM87XX_PHY=y
CONFIG_BCM_NET_PHYLIB=y
# CONFIG_BROADCOM_PHY is not set
# CONFIG_CICADA_PHY is not set
CONFIG_DAVICOM_PHY=y
# CONFIG_DP83848_PHY is not set
CONFIG_DP83867_PHY=y
CONFIG_FIXED_PHY=y
CONFIG_ICPLUS_PHY=y
# CONFIG_INTEL_XWAY_PHY is not set
CONFIG_LSI_ET1011C_PHY=y
# CONFIG_LXT_PHY is not set
CONFIG_MARVELL_PHY=y
CONFIG_MICREL_PHY=y
CONFIG_MICROCHIP_PHY=y
CONFIG_MICROSEMI_PHY=y
CONFIG_NATIONAL_PHY=y
CONFIG_QSEMI_PHY=y
CONFIG_REALTEK_PHY=y
CONFIG_SMSC_PHY=y
CONFIG_STE10XP=y
# CONFIG_TERANETICS_PHY is not set
CONFIG_VITESSE_PHY=y
CONFIG_XILINX_GMII2RGMII=y
CONFIG_PLIP=y
CONFIG_PPP=y
# CONFIG_PPP_BSDCOMP is not set
CONFIG_PPP_DEFLATE=y
# CONFIG_PPP_FILTER is not set
# CONFIG_PPP_MPPE is not set
# CONFIG_PPP_MULTILINK is not set
# CONFIG_PPPOATM is not set
# CONFIG_PPPOE is not set
# CONFIG_PPPOL2TP is not set
CONFIG_PPP_ASYNC=y
# CONFIG_PPP_SYNC_TTY is not set
CONFIG_SLIP=y
CONFIG_SLHC=y
CONFIG_SLIP_COMPRESSED=y
# CONFIG_SLIP_SMART is not set
CONFIG_SLIP_MODE_SLIP6=y
CONFIG_USB_NET_DRIVERS=y
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=y
CONFIG_USB_RTL8150=y
CONFIG_USB_RTL8152=y
# CONFIG_USB_LAN78XX is not set
# CONFIG_USB_USBNET is not set
CONFIG_USB_IPHETH=y
CONFIG_WLAN=y
CONFIG_WLAN_VENDOR_ADMTEK=y
CONFIG_WLAN_VENDOR_ATH=y
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K_PCI is not set
# CONFIG_WLAN_VENDOR_ATMEL is not set
CONFIG_WLAN_VENDOR_BROADCOM=y
CONFIG_WLAN_VENDOR_CISCO=y
CONFIG_WLAN_VENDOR_INTEL=y
# CONFIG_WLAN_VENDOR_INTERSIL is not set
# CONFIG_WLAN_VENDOR_MARVELL is not set
# CONFIG_WLAN_VENDOR_MEDIATEK is not set
# CONFIG_WLAN_VENDOR_RALINK is not set
CONFIG_WLAN_VENDOR_REALTEK=y
CONFIG_WLAN_VENDOR_RSI=y
# CONFIG_WLAN_VENDOR_ST is not set
CONFIG_WLAN_VENDOR_TI=y
CONFIG_WLAN_VENDOR_ZYDAS=y

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=y
CONFIG_WIMAX_I2400M_USB=y
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8
# CONFIG_WAN is not set
# CONFIG_IEEE802154_DRIVERS is not set
CONFIG_VMXNET3=y
# CONFIG_FUJITSU_ES is not set
CONFIG_HYPERV_NET=y
CONFIG_ISDN=y
CONFIG_ISDN_I4L=y
CONFIG_ISDN_PPP=y
# CONFIG_ISDN_PPP_VJ is not set
CONFIG_ISDN_MPP=y
CONFIG_IPPP_FILTER=y
# CONFIG_ISDN_PPP_BSDCOMP is not set
CONFIG_ISDN_AUDIO=y
# CONFIG_ISDN_TTY_FAX is not set
CONFIG_ISDN_X25=y

#
# ISDN feature submodules
#
# CONFIG_ISDN_DIVERSION is not set

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
CONFIG_ISDN_DRV_HISAX=y

#
# D-channel protocol features
#
# CONFIG_HISAX_EURO is not set
# CONFIG_HISAX_1TR6 is not set
# CONFIG_HISAX_NI1 is not set
CONFIG_HISAX_MAX_CARDS=8

#
# HiSax supported cards
#
CONFIG_HISAX_16_3=y
# CONFIG_HISAX_TELESPCI is not set
# CONFIG_HISAX_S0BOX is not set
CONFIG_HISAX_FRITZPCI=y
CONFIG_HISAX_AVM_A1_PCMCIA=y
# CONFIG_HISAX_ELSA is not set
# CONFIG_HISAX_DIEHLDIVA is not set
CONFIG_HISAX_SEDLBAUER=y
CONFIG_HISAX_NETJET=y
CONFIG_HISAX_NETJET_U=y
CONFIG_HISAX_NICCY=y
CONFIG_HISAX_BKM_A4T=y
CONFIG_HISAX_SCT_QUADRO=y
CONFIG_HISAX_GAZEL=y
CONFIG_HISAX_HFC_PCI=y
# CONFIG_HISAX_W6692 is not set
CONFIG_HISAX_HFC_SX=y
CONFIG_HISAX_ENTERNOW_PCI=y
# CONFIG_HISAX_DEBUG is not set

#
# HiSax PCMCIA card service modules
#

#
# HiSax sub driver modules
#
CONFIG_HISAX_ST5481=y
# CONFIG_HISAX_HFCUSB is not set
CONFIG_HISAX_HFC4S8S=y
# CONFIG_HISAX_FRITZ_PCIPNP is not set
# CONFIG_ISDN_CAPI is not set
# CONFIG_ISDN_DRV_GIGASET is not set
CONFIG_MISDN=y
CONFIG_MISDN_DSP=y
CONFIG_MISDN_L1OIP=y

#
# mISDN hardware drivers
#
CONFIG_MISDN_HFCPCI=y
CONFIG_MISDN_HFCMULTI=y
CONFIG_MISDN_HFCUSB=y
CONFIG_MISDN_AVMFRITZ=y
# CONFIG_MISDN_SPEEDFAX is not set
CONFIG_MISDN_INFINEON=y
CONFIG_MISDN_W6692=y
# CONFIG_MISDN_NETJET is not set
CONFIG_MISDN_IPAC=y
CONFIG_ISDN_HDLC=y
CONFIG_NVM=y
# CONFIG_NVM_DEBUG is not set
CONFIG_NVM_RRPC=y

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_OMAP4 is not set
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
# CONFIG_KEYBOARD_CAP11XX is not set
# CONFIG_KEYBOARD_BCM is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_PROPERTIES=y
# CONFIG_TOUCHSCREEN_88PM860X is not set
CONFIG_TOUCHSCREEN_AD7879=y
# CONFIG_TOUCHSCREEN_AD7879_I2C is not set
# CONFIG_TOUCHSCREEN_AR1021_I2C is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
# CONFIG_TOUCHSCREEN_BU21013 is not set
CONFIG_TOUCHSCREEN_CHIPONE_ICN8318=y
CONFIG_TOUCHSCREEN_CY8CTMG110=y
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP_I2C=y
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP4_I2C=y
# CONFIG_TOUCHSCREEN_DA9034 is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
CONFIG_TOUCHSCREEN_EETI=y
CONFIG_TOUCHSCREEN_EGALAX=y
# CONFIG_TOUCHSCREEN_EGALAX_SERIAL is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_GOODIX=y
CONFIG_TOUCHSCREEN_ILI210X=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_EKTF2127=y
CONFIG_TOUCHSCREEN_ELAN=y
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
# CONFIG_TOUCHSCREEN_MAX11801 is not set
# CONFIG_TOUCHSCREEN_MCS5000 is not set
CONFIG_TOUCHSCREEN_MMS114=y
# CONFIG_TOUCHSCREEN_MELFAS_MIP4 is not set
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_IMX6UL_TSC=y
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
CONFIG_TOUCHSCREEN_TOUCHWIN=y
# CONFIG_TOUCHSCREEN_TI_AM335X_TSC is not set
CONFIG_TOUCHSCREEN_UCB1400=y
CONFIG_TOUCHSCREEN_PIXCIR=y
CONFIG_TOUCHSCREEN_WDT87XX_I2C=y
# CONFIG_TOUCHSCREEN_WM97XX is not set
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
CONFIG_TOUCHSCREEN_USB_ELO=y
CONFIG_TOUCHSCREEN_USB_E2I=y
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=y
CONFIG_TOUCHSCREEN_USB_NEXIO=y
CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC_SERIO=y
CONFIG_TOUCHSCREEN_TSC200X_CORE=y
CONFIG_TOUCHSCREEN_TSC2004=y
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_RM_TS is not set
# CONFIG_TOUCHSCREEN_SILEAD is not set
# CONFIG_TOUCHSCREEN_SIS_I2C is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
CONFIG_TOUCHSCREEN_SX8654=y
CONFIG_TOUCHSCREEN_TPS6507X=y
CONFIG_TOUCHSCREEN_ZET6223=y
CONFIG_TOUCHSCREEN_ZFORCE=y
# CONFIG_TOUCHSCREEN_ROHM_BU21023 is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM860X_ONKEY=y
CONFIG_INPUT_AD714X=y
CONFIG_INPUT_AD714X_I2C=y
CONFIG_INPUT_ATMEL_CAPTOUCH=y
CONFIG_INPUT_BMA150=y
CONFIG_INPUT_E3X0_BUTTON=y
CONFIG_INPUT_PCSPKR=y
CONFIG_INPUT_MAX8925_ONKEY=y
CONFIG_INPUT_MMA8450=y
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_GP2A=y
# CONFIG_INPUT_GPIO_BEEPER is not set
CONFIG_INPUT_GPIO_TILT_POLLED=y
# CONFIG_INPUT_GPIO_DECODER is not set
CONFIG_INPUT_ATLAS_BTNS=y
CONFIG_INPUT_ATI_REMOTE2=y
CONFIG_INPUT_KEYSPAN_REMOTE=y
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
CONFIG_INPUT_YEALINK=y
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_REGULATOR_HAPTIC=y
# CONFIG_INPUT_RETU_PWRBUTTON is not set
CONFIG_INPUT_TPS65218_PWRBUTTON=y
CONFIG_INPUT_AXP20X_PEK=y
CONFIG_INPUT_UINPUT=y
# CONFIG_INPUT_PCF8574 is not set
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
CONFIG_INPUT_DA9063_ONKEY=y
CONFIG_INPUT_ADXL34X=y
CONFIG_INPUT_ADXL34X_I2C=y
CONFIG_INPUT_IMS_PCU=y
# CONFIG_INPUT_CMA3000 is not set
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set
CONFIG_INPUT_DRV260X_HAPTICS=y
CONFIG_INPUT_DRV2665_HAPTICS=y
CONFIG_INPUT_DRV2667_HAPTICS=y
CONFIG_RMI4_CORE=y
CONFIG_RMI4_I2C=y
CONFIG_RMI4_SMB=y
CONFIG_RMI4_F03=y
CONFIG_RMI4_F03_SERIO=y
CONFIG_RMI4_2D_SENSOR=y
CONFIG_RMI4_F11=y
CONFIG_RMI4_F12=y
CONFIG_RMI4_F30=y
# CONFIG_RMI4_F34 is not set
CONFIG_RMI4_F54=y
CONFIG_RMI4_F55=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
CONFIG_SERIO_APBPS2=y
CONFIG_HYPERV_KEYBOARD=y
CONFIG_USERIO=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_NOZOMI=y
CONFIG_N_GSM=y
# CONFIG_TRACE_ROUTER is not set
CONFIG_TRACE_SINK=y
CONFIG_DEVMEM=y
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_FINTEK=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_EXAR is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y
# CONFIG_SERIAL_8250_FSL is not set
CONFIG_SERIAL_8250_DW=y
CONFIG_SERIAL_8250_RT288X=y
CONFIG_SERIAL_8250_LPSS=y
CONFIG_SERIAL_8250_MID=y
CONFIG_SERIAL_8250_MOXA=y
# CONFIG_SERIAL_OF_PLATFORM is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_UARTLITE=y
CONFIG_SERIAL_UARTLITE_CONSOLE=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
CONFIG_SERIAL_SCCNXP=y
# CONFIG_SERIAL_SCCNXP_CONSOLE is not set
CONFIG_SERIAL_SC16IS7XX=y
# CONFIG_SERIAL_SC16IS7XX_I2C is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_XILINX_PS_UART=y
# CONFIG_SERIAL_XILINX_PS_UART_CONSOLE is not set
# CONFIG_SERIAL_ARC is not set
CONFIG_SERIAL_RP2=y
CONFIG_SERIAL_RP2_NR_UARTS=32
CONFIG_SERIAL_FSL_LPUART=y
CONFIG_SERIAL_FSL_LPUART_CONSOLE=y
# CONFIG_SERIAL_CONEXANT_DIGICOLOR is not set
# CONFIG_SERIAL_MEN_Z135 is not set
CONFIG_SERIAL_DEV_BUS=y
CONFIG_SERIAL_DEV_CTRL_TTYPORT=y
CONFIG_PRINTER=y
# CONFIG_LP_CONSOLE is not set
# CONFIG_PPDEV is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
CONFIG_R3964=y
CONFIG_APPLICOM=y
CONFIG_MWAVE=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HPET_MMAP_DEFAULT is not set
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_XILLYBUS is not set

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_ARB_GPIO_CHALLENGE=y
CONFIG_I2C_MUX_GPIO=y
CONFIG_I2C_MUX_PCA9541=y
# CONFIG_I2C_MUX_PCA954x is not set
CONFIG_I2C_MUX_PINCTRL=y
# CONFIG_I2C_MUX_REG is not set
CONFIG_I2C_DEMUX_PINCTRL=y
CONFIG_I2C_MUX_MLXCPLD=y
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=y
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=y
# CONFIG_I2C_AMD756_S4882 is not set
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
CONFIG_I2C_ISMT=y
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
# CONFIG_I2C_SIS5595 is not set
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
# CONFIG_I2C_VIA is not set
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
CONFIG_I2C_SCMI=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=y
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
CONFIG_I2C_DESIGNWARE_PCI=y
# CONFIG_I2C_EMEV2 is not set
CONFIG_I2C_GPIO=y
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_RK3X=y
CONFIG_I2C_SIMTEC=y
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_DLN2 is not set
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_ROBOTFUZZ_OSIF=y
CONFIG_I2C_TAOS_EVM=y
CONFIG_I2C_TINY_USB=y
CONFIG_I2C_VIPERBOARD=y

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_MLXCPLD=y
CONFIG_I2C_CROS_EC_TUNNEL=y
# CONFIG_I2C_SLAVE is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
CONFIG_SPMI=y
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI controllers
#

#
# HSI clients
#
CONFIG_HSI_CHAR=y

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_PARPORT is not set
CONFIG_PPS_CLIENT_GPIO=y

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_PTP_1588_CLOCK_KVM=y
CONFIG_PINCTRL=y

#
# Pin controllers
#
CONFIG_GENERIC_PINCTRL_GROUPS=y
CONFIG_PINMUX=y
CONFIG_GENERIC_PINMUX_FUNCTIONS=y
CONFIG_PINCONF=y
CONFIG_GENERIC_PINCONF=y
CONFIG_DEBUG_PINCTRL=y
# CONFIG_PINCTRL_AS3722 is not set
# CONFIG_PINCTRL_AMD is not set
CONFIG_PINCTRL_SINGLE=y
CONFIG_PINCTRL_SX150X=y
CONFIG_PINCTRL_BAYTRAIL=y
CONFIG_PINCTRL_CHERRYVIEW=y
CONFIG_PINCTRL_MERRIFIELD=y
CONFIG_PINCTRL_INTEL=y
CONFIG_PINCTRL_BROXTON=y
CONFIG_PINCTRL_GEMINILAKE=y
# CONFIG_PINCTRL_SUNRISEPOINT is not set
CONFIG_GPIOLIB=y
CONFIG_OF_GPIO=y
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers
#
CONFIG_GPIO_74XX_MMIO=y
# CONFIG_GPIO_ALTERA is not set
CONFIG_GPIO_AMDPT=y
CONFIG_GPIO_AXP209=y
CONFIG_GPIO_DWAPB=y
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_GRGPIO=y
# CONFIG_GPIO_ICH is not set
CONFIG_GPIO_LYNXPOINT=y
CONFIG_GPIO_MENZ127=y
CONFIG_GPIO_MOCKUP=y
# CONFIG_GPIO_SYSCON is not set
CONFIG_GPIO_VX855=y
# CONFIG_GPIO_XILINX is not set

#
# Port-mapped I/O GPIO drivers
#
# CONFIG_GPIO_F7188X is not set
CONFIG_GPIO_IT87=y
CONFIG_GPIO_SCH=y
CONFIG_GPIO_SCH311X=y

#
# I2C GPIO expanders
#
CONFIG_GPIO_ADP5588=y
# CONFIG_GPIO_ADP5588_IRQ is not set
CONFIG_GPIO_ADNP=y
CONFIG_GPIO_MAX7300=y
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=y
# CONFIG_GPIO_PCA953X_IRQ is not set
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_SX150X=y
# CONFIG_GPIO_TPIC2810 is not set

#
# MFD GPIO expanders
#
# CONFIG_GPIO_ARIZONA is not set
CONFIG_GPIO_CRYSTAL_COVE=y
CONFIG_GPIO_DLN2=y
CONFIG_GPIO_JANZ_TTL=y
CONFIG_GPIO_MSIC=y
CONFIG_GPIO_RC5T583=y
# CONFIG_GPIO_TC3589X is not set
CONFIG_GPIO_TPS65218=y
# CONFIG_GPIO_TPS65912 is not set
# CONFIG_GPIO_UCB1400 is not set
CONFIG_GPIO_WHISKEY_COVE=y
# CONFIG_GPIO_WM8350 is not set
CONFIG_GPIO_WM8994=y

#
# PCI GPIO expanders
#
CONFIG_GPIO_AMD8111=y
CONFIG_GPIO_BT8XX=y
# CONFIG_GPIO_INTEL_MID is not set
CONFIG_GPIO_MERRIFIELD=y
CONFIG_GPIO_ML_IOH=y
CONFIG_GPIO_PCI_IDIO_16=y
CONFIG_GPIO_RDC321X=y
CONFIG_GPIO_SODAVILLE=y

#
# SPI or I2C GPIO expanders
#
CONFIG_GPIO_MCP23S08=y

#
# USB GPIO expanders
#
CONFIG_GPIO_VIPERBOARD=y
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2490=y
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2405 is not set
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2408_READBACK=y
CONFIG_W1_SLAVE_DS2413=y
# CONFIG_W1_SLAVE_DS2406 is not set
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=y
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
# CONFIG_POWER_AVS is not set
CONFIG_POWER_RESET=y
CONFIG_POWER_RESET_AS3722=y
# CONFIG_POWER_RESET_GPIO is not set
CONFIG_POWER_RESET_GPIO_RESTART=y
# CONFIG_POWER_RESET_LTC2952 is not set
# CONFIG_POWER_RESET_RESTART is not set
CONFIG_POWER_RESET_SYSCON=y
CONFIG_POWER_RESET_SYSCON_POWEROFF=y
# CONFIG_SYSCON_REBOOT_MODE is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
# CONFIG_MAX8925_POWER is not set
CONFIG_WM8350_POWER=y
CONFIG_TEST_POWER=y
CONFIG_BATTERY_88PM860X=y
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_SBS=y
CONFIG_CHARGER_SBS=y
CONFIG_BATTERY_BQ27XXX=y
CONFIG_BATTERY_BQ27XXX_I2C=y
CONFIG_BATTERY_DA9030=y
CONFIG_BATTERY_DA9150=y
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_88PM860X=y
CONFIG_CHARGER_ISP1704=y
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_MANAGER=y
CONFIG_CHARGER_MAX14577=y
# CONFIG_CHARGER_DETECTOR_MAX14656 is not set
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_BQ24190=y
# CONFIG_CHARGER_BQ24257 is not set
CONFIG_CHARGER_BQ24735=y
CONFIG_CHARGER_BQ25890=y
CONFIG_CHARGER_SMB347=y
CONFIG_CHARGER_TPS65217=y
CONFIG_BATTERY_GAUGE_LTC2941=y
CONFIG_BATTERY_RT5033=y
CONFIG_CHARGER_RT9455=y
# CONFIG_AXP20X_POWER is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7410=y
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DELL_SMM=y
CONFIG_SENSORS_I5K_AMB=y
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_GL518SM=y
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
# CONFIG_SENSORS_GPIO_FAN is not set
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_I5500=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_POWR1220=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LTC2945=y
# CONFIG_SENSORS_LTC2990 is not set
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4222=y
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4260=y
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_MAX31790=y
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_TC654=y
CONFIG_SENSORS_MENF21BMC_HWMON=y
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM73=y
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=y
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_NTC_THERMISTOR=y
CONFIG_SENSORS_NCT6683=y
CONFIG_SENSORS_NCT6775=y
# CONFIG_SENSORS_NCT7802 is not set
# CONFIG_SENSORS_NCT7904 is not set
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
# CONFIG_SENSORS_ADM1275 is not set
CONFIG_SENSORS_LM25066=y
CONFIG_SENSORS_LTC2978=y
# CONFIG_SENSORS_LTC2978_REGULATOR is not set
CONFIG_SENSORS_LTC3815=y
# CONFIG_SENSORS_MAX16064 is not set
CONFIG_SENSORS_MAX20751=y
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
CONFIG_SENSORS_TPS40422=y
CONFIG_SENSORS_UCD9000=y
CONFIG_SENSORS_UCD9200=y
CONFIG_SENSORS_ZL6100=y
CONFIG_SENSORS_SHT15=y
# CONFIG_SENSORS_SHT21 is not set
CONFIG_SENSORS_SHT3x=y
CONFIG_SENSORS_SHTC1=y
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
# CONFIG_SENSORS_EMC6W201 is not set
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_STTS751 is not set
CONFIG_SENSORS_SMM665=y
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
# CONFIG_SENSORS_INA3221 is not set
CONFIG_SENSORS_TC74=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
# CONFIG_SENSORS_TMP103 is not set
# CONFIG_SENSORS_TMP108 is not set
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_VIA_CPUTEMP=y
CONFIG_SENSORS_VIA686A=y
# CONFIG_SENSORS_VT1211 is not set
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM8350=y
CONFIG_SENSORS_XGENE=y

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=y
CONFIG_SENSORS_ATK0110=y
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_OF=y
# CONFIG_THERMAL_WRITABLE_TRIPS is not set
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_DEFAULT_GOV_POWER_ALLOCATOR is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_BANG_BANG=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_POWER_ALLOCATOR is not set
CONFIG_CPU_THERMAL=y
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_QORIQ_THERMAL is not set
CONFIG_INTEL_POWERCLAMP=y
CONFIG_INTEL_SOC_DTS_IOSF_CORE=y
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
CONFIG_INT340X_THERMAL=y
CONFIG_ACPI_THERMAL_REL=y
CONFIG_INT3406_THERMAL=y
CONFIG_INTEL_BXT_PMIC_THERMAL=y
CONFIG_INTEL_PCH_THERMAL=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_ACT8945A is not set
CONFIG_MFD_AS3711=y
CONFIG_MFD_AS3722=y
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_ATMEL_FLEXCOM=y
CONFIG_MFD_ATMEL_HLCDC=y
CONFIG_MFD_BCM590XX=y
CONFIG_MFD_AXP20X=y
CONFIG_MFD_AXP20X_I2C=y
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=y
CONFIG_PMIC_DA903X=y
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9062 is not set
CONFIG_MFD_DA9063=y
CONFIG_MFD_DA9150=y
CONFIG_MFD_DLN2=y
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_MFD_HI6421_PMIC=y
CONFIG_HTC_PASIC3=y
CONFIG_HTC_I2CPLD=y
CONFIG_MFD_INTEL_QUARK_I2C_GPIO=y
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_INTEL_SOC_PMIC=y
CONFIG_MFD_INTEL_LPSS=y
CONFIG_MFD_INTEL_LPSS_ACPI=y
# CONFIG_MFD_INTEL_LPSS_PCI is not set
CONFIG_MFD_INTEL_MSIC=y
CONFIG_MFD_JANZ_CMODIO=y
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=y
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX14577=y
# CONFIG_MFD_MAX77620 is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX77843=y
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_MT6397 is not set
CONFIG_MFD_MENF21BMC=y
CONFIG_MFD_VIPERBOARD=y
CONFIG_MFD_RETU=y
# CONFIG_MFD_PCF50633 is not set
CONFIG_UCB1400_CORE=y
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_RT5033=y
# CONFIG_MFD_RTSX_USB is not set
CONFIG_MFD_RC5T583=y
CONFIG_MFD_RK808=y
CONFIG_MFD_RN5T618=y
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
# CONFIG_MFD_SKY81452 is not set
CONFIG_MFD_SMSC=y
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
CONFIG_AB3100_OTP=y
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
# CONFIG_MFD_TPS65086 is not set
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TI_LP873X is not set
CONFIG_MFD_TPS65218=y
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_CS47L24 is not set
CONFIG_MFD_WM5102=y
# CONFIG_MFD_WM5110 is not set
# CONFIG_MFD_WM8997 is not set
# CONFIG_MFD_WM8998 is not set
CONFIG_MFD_WM8400=y
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_FIXED_VOLTAGE is not set
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
# CONFIG_REGULATOR_88PM8607 is not set
# CONFIG_REGULATOR_ACT8865 is not set
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_ANATOP=y
CONFIG_REGULATOR_AAT2870=y
CONFIG_REGULATOR_AB3100=y
CONFIG_REGULATOR_AS3711=y
# CONFIG_REGULATOR_AS3722 is not set
CONFIG_REGULATOR_AXP20X=y
# CONFIG_REGULATOR_BCM590XX is not set
CONFIG_REGULATOR_DA903X=y
# CONFIG_REGULATOR_DA9063 is not set
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_DA9211=y
CONFIG_REGULATOR_FAN53555=y
# CONFIG_REGULATOR_GPIO is not set
# CONFIG_REGULATOR_HI6421 is not set
CONFIG_REGULATOR_ISL9305=y
# CONFIG_REGULATOR_ISL6271A is not set
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
# CONFIG_REGULATOR_LP872X is not set
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LTC3589=y
CONFIG_REGULATOR_LTC3676=y
# CONFIG_REGULATOR_MAX14577 is not set
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8907=y
CONFIG_REGULATOR_MAX8925=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
# CONFIG_REGULATOR_MAX77693 is not set
# CONFIG_REGULATOR_MT6311 is not set
CONFIG_REGULATOR_PFUZE100=y
# CONFIG_REGULATOR_PV88060 is not set
# CONFIG_REGULATOR_PV88080 is not set
# CONFIG_REGULATOR_PV88090 is not set
CONFIG_REGULATOR_QCOM_SPMI=y
# CONFIG_REGULATOR_RC5T583 is not set
CONFIG_REGULATOR_RK808=y
CONFIG_REGULATOR_RN5T618=y
CONFIG_REGULATOR_RT5033=y
# CONFIG_REGULATOR_TPS51632 is not set
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65217=y
# CONFIG_REGULATOR_TPS65218 is not set
CONFIG_REGULATOR_TPS65912=y
CONFIG_REGULATOR_WM8350=y
CONFIG_REGULATOR_WM8400=y
# CONFIG_REGULATOR_WM8994 is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
# CONFIG_MEDIA_RADIO_SUPPORT is not set
CONFIG_MEDIA_SDR_SUPPORT=y
# CONFIG_MEDIA_RC_SUPPORT is not set
# CONFIG_MEDIA_CEC_SUPPORT is not set
CONFIG_MEDIA_CONTROLLER=y
CONFIG_MEDIA_CONTROLLER_DVB=y
CONFIG_VIDEO_DEV=y
# CONFIG_VIDEO_V4L2_SUBDEV_API is not set
CONFIG_VIDEO_V4L2=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_VMALLOC=y
CONFIG_DVB_CORE=y
# CONFIG_DVB_NET is not set
# CONFIG_TTPCI_EEPROM is not set
CONFIG_DVB_MAX_ADAPTERS=16
# CONFIG_DVB_DYNAMIC_MINORS is not set
CONFIG_DVB_DEMUX_SECTION_LOSS_LOG=y

#
# Media drivers
#
# CONFIG_MEDIA_USB_SUPPORT is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
# CONFIG_DVB_PLATFORM_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
# CONFIG_SMS_SDIO_DRV is not set

#
# Supported FireWire (IEEE 1394) Adapters
#
CONFIG_DVB_FIREDTV=y
CONFIG_DVB_FIREDTV_INPUT=y
CONFIG_CYPRESS_FIRMWARE=y

#
# Media ancillary drivers (tuners, sensors, i2c, spi, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y

#
# Audio decoders, processors and mixers
#

#
# RDS decoders
#

#
# Video decoders
#

#
# Video and audio decoders
#

#
# Video encoders
#

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#

#
# Audio/Video compression chips
#

#
# Miscellaneous helper chips
#

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=y
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MC44S803=y

#
# Multistandard (satellite) frontends
#

#
# Multistandard (cable + terrestrial) frontends
#

#
# DVB-S (satellite) frontends
#

#
# DVB-T (terrestrial) frontends
#
# CONFIG_DVB_AS102_FE is not set
# CONFIG_DVB_GP8PSK_FE is not set

#
# DVB-C (cable) frontends
#

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#

#
# ISDB-T (terrestrial) frontends
#

#
# ISDB-S (satellite) & ISDB-T (terrestrial) frontends
#

#
# Digital terrestrial only tuners/PLL
#

#
# SEC control devices for DVB-S
#

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_AMD64 is not set
CONFIG_AGP_INTEL=y
# CONFIG_AGP_SIS is not set
CONFIG_AGP_VIA=y
CONFIG_INTEL_GTT=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set

#
# ACP (Audio CoProcessor) Configuration
#
# CONFIG_DRM_LIB_RANDOM is not set

#
# Frame buffer Devices
#
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_CMDLINE=y
CONFIG_FB_NOTIFY=y
CONFIG_FB_DDC=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_PROVIDE_GET_FB_UNMAPPED_AREA is not set
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=y
CONFIG_FB_PM2=y
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=y
CONFIG_FB_ASILIANT=y
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=y
# CONFIG_FB_VESA is not set
# CONFIG_FB_EFI is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
CONFIG_FB_OPENCORES=y
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
CONFIG_FB_RIVA=y
CONFIG_FB_RIVA_I2C=y
CONFIG_FB_RIVA_DEBUG=y
CONFIG_FB_RIVA_BACKLIGHT=y
CONFIG_FB_I740=y
# CONFIG_FB_LE80578 is not set
CONFIG_FB_MATROX=y
# CONFIG_FB_MATROX_MILLENIUM is not set
CONFIG_FB_MATROX_MYSTIQUE=y
# CONFIG_FB_MATROX_G is not set
# CONFIG_FB_MATROX_I2C is not set
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
# CONFIG_FB_RADEON_BACKLIGHT is not set
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=y
# CONFIG_FB_ATY128_BACKLIGHT is not set
CONFIG_FB_ATY=y
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
# CONFIG_FB_S3 is not set
CONFIG_FB_SAVAGE=y
CONFIG_FB_SAVAGE_I2C=y
# CONFIG_FB_SAVAGE_ACCEL is not set
CONFIG_FB_SIS=y
# CONFIG_FB_SIS_300 is not set
CONFIG_FB_SIS_315=y
CONFIG_FB_VIA=y
CONFIG_FB_VIA_DIRECT_PROCFS=y
CONFIG_FB_VIA_X_COMPATIBILITY=y
CONFIG_FB_NEOMAGIC=y
# CONFIG_FB_KYRO is not set
CONFIG_FB_3DFX=y
CONFIG_FB_3DFX_ACCEL=y
CONFIG_FB_3DFX_I2C=y
CONFIG_FB_VOODOO1=y
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=y
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
CONFIG_FB_SM501=y
CONFIG_FB_SMSCUFX=y
CONFIG_FB_UDL=y
CONFIG_FB_IBM_GXT4500=y
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_FB_MB862XX_I2C is not set
CONFIG_FB_BROADSHEET=y
CONFIG_FB_AUO_K190X=y
# CONFIG_FB_AUO_K1900 is not set
CONFIG_FB_AUO_K1901=y
CONFIG_FB_HYPERV=y
CONFIG_FB_SIMPLE=y
# CONFIG_FB_SSD1307 is not set
# CONFIG_FB_SM712 is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_PLATFORM=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_LM3533=y
CONFIG_BACKLIGHT_DA903X=y
# CONFIG_BACKLIGHT_MAX8925 is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_PM8941_WLED=y
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_ADP8860=y
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_88PM860X=y
CONFIG_BACKLIGHT_AAT2870=y
# CONFIG_BACKLIGHT_LM3639 is not set
# CONFIG_BACKLIGHT_TPS65217 is not set
CONFIG_BACKLIGHT_AS3711=y
# CONFIG_BACKLIGHT_GPIO is not set
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
CONFIG_VGASTATE=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_VGACON_SOFT_SCROLLBACK_PERSISTENT_ENABLE_BY_DEFAULT=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_DUMMY_CONSOLE_COLUMNS=80
CONFIG_DUMMY_CONSOLE_ROWS=25
# CONFIG_FRAMEBUFFER_CONSOLE is not set
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_SEQUENCER=y
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_PCM_TIMER=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=y
# CONFIG_SND_SEQ_HRTIMER_DEFAULT is not set
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_PROC_FS=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
CONFIG_SND_DEBUG=y
# CONFIG_SND_DEBUG_VERBOSE is not set
CONFIG_SND_PCM_XRUN_DEBUG=y
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=y
CONFIG_SND_OPL3_LIB_SEQ=y
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=y
CONFIG_SND_OPL3_LIB=y
CONFIG_SND_AC97_CODEC=y
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_SB_COMMON=y
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=y
# CONFIG_SND_ALS300 is not set
CONFIG_SND_ALS4000=y
CONFIG_SND_ALI5451=y
CONFIG_SND_ASIHPI=y
CONFIG_SND_ATIIXP=y
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
CONFIG_SND_AU8820=y
CONFIG_SND_AU8830=y
CONFIG_SND_AW2=y
# CONFIG_SND_AZT3328 is not set
CONFIG_SND_BT87X=y
# CONFIG_SND_BT87X_OVERCLOCK is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
CONFIG_SND_OXYGEN_LIB=y
CONFIG_SND_OXYGEN=y
CONFIG_SND_CS4281=y
CONFIG_SND_CS46XX=y
CONFIG_SND_CS46XX_NEW_DSP=y
# CONFIG_SND_CTXFI is not set
CONFIG_SND_DARLA20=y
CONFIG_SND_GINA20=y
CONFIG_SND_LAYLA20=y
CONFIG_SND_DARLA24=y
# CONFIG_SND_GINA24 is not set
CONFIG_SND_LAYLA24=y
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
CONFIG_SND_ECHO3G=y
CONFIG_SND_INDIGO=y
CONFIG_SND_INDIGOIO=y
CONFIG_SND_INDIGODJ=y
CONFIG_SND_INDIGOIOX=y
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
CONFIG_SND_EMU10K1X=y
# CONFIG_SND_ENS1370 is not set
CONFIG_SND_ENS1371=y
CONFIG_SND_ES1938=y
CONFIG_SND_ES1968=y
CONFIG_SND_ES1968_INPUT=y
CONFIG_SND_FM801=y
# CONFIG_SND_HDSP is not set
CONFIG_SND_HDSPM=y
CONFIG_SND_ICE1712=y
CONFIG_SND_ICE1724=y
CONFIG_SND_INTEL8X0=y
# CONFIG_SND_INTEL8X0M is not set
CONFIG_SND_KORG1212=y
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
CONFIG_SND_MIXART=y
CONFIG_SND_NM256=y
CONFIG_SND_PCXHR=y
# CONFIG_SND_RIPTIDE is not set
CONFIG_SND_RME32=y
CONFIG_SND_RME96=y
# CONFIG_SND_RME9652 is not set
CONFIG_SND_SONICVIBES=y
CONFIG_SND_TRIDENT=y
CONFIG_SND_VIA82XX=y
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set

#
# HD-Audio
#
# CONFIG_SND_HDA_INTEL is not set
CONFIG_SND_HDA_PREALLOC_SIZE=64
CONFIG_SND_USB=y
# CONFIG_SND_USB_AUDIO is not set
CONFIG_SND_USB_UA101=y
# CONFIG_SND_USB_USX2Y is not set
CONFIG_SND_USB_CAIAQ=y
CONFIG_SND_USB_CAIAQ_INPUT=y
# CONFIG_SND_USB_US122L is not set
CONFIG_SND_USB_6FIRE=y
CONFIG_SND_USB_HIFACE=y
CONFIG_SND_BCD2000=y
CONFIG_SND_USB_LINE6=y
# CONFIG_SND_USB_POD is not set
CONFIG_SND_USB_PODHD=y
# CONFIG_SND_USB_TONEPORT is not set
# CONFIG_SND_USB_VARIAX is not set
CONFIG_SND_FIREWIRE=y
CONFIG_SND_FIREWIRE_LIB=y
CONFIG_SND_DICE=y
CONFIG_SND_OXFW=y
CONFIG_SND_ISIGHT=y
CONFIG_SND_FIREWORKS=y
CONFIG_SND_BEBOB=y
CONFIG_SND_FIREWIRE_DIGI00X=y
CONFIG_SND_FIREWIRE_TASCAM=y
# CONFIG_SND_SOC is not set
# CONFIG_SND_X86 is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=y

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CORSAIR=y
CONFIG_HID_PRODIKEYS=y
CONFIG_HID_CMEDIA=y
# CONFIG_HID_CYPRESS is not set
CONFIG_HID_DRAGONRISE=y
CONFIG_DRAGONRISE_FF=y
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=y
CONFIG_HID_EZKEY=y
CONFIG_HID_GEMBIRD=y
CONFIG_HID_GFRM=y
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
CONFIG_HID_WALTOP=y
# CONFIG_HID_GYRATION is not set
CONFIG_HID_ICADE=y
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
CONFIG_HID_LCPOWER=y
CONFIG_HID_LED=y
CONFIG_HID_LENOVO=y
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_HIDPP=y
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MAYFLASH is not set
# CONFIG_HID_MICROSOFT is not set
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=y
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PLANTRONICS is not set
CONFIG_HID_PRIMAX=y
CONFIG_HID_SAITEK=y
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SPEEDLINK=y
# CONFIG_HID_STEELSERIES is not set
CONFIG_HID_SUNPLUS=y
CONFIG_HID_RMI=y
CONFIG_HID_GREENASIA=y
CONFIG_GREENASIA_FF=y
CONFIG_HID_HYPERV_MOUSE=y
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
CONFIG_HID_THINGM=y
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_UDRAW_PS3=y
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_XINMO=y
# CONFIG_HID_ZEROPLUS is not set
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y
# CONFIG_HID_SENSOR_CUSTOM_SENSOR is not set
CONFIG_HID_ALPS=y

#
# USB HID support
#
# CONFIG_USB_HID is not set
CONFIG_HID_PID=y

#
# I2C HID support
#
# CONFIG_I2C_HID is not set

#
# Intel ISH HID support
#
# CONFIG_INTEL_ISH_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
# CONFIG_USB_DEFAULT_PERSIST is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
CONFIG_USB_OTG_WHITELIST=y
CONFIG_USB_LEDS_TRIGGER_USBPORT=y
CONFIG_USB_MON=y
CONFIG_USB_WUSB=y
CONFIG_USB_WUSB_CBAF=y
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
CONFIG_USB_EHCI_HCD_PLATFORM=y
CONFIG_USB_OXU210HP_HCD=y
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_HCD_PCI is not set
# CONFIG_USB_OHCI_HCD_SSB is not set
CONFIG_USB_OHCI_HCD_PLATFORM=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_U132_HCD=y
# CONFIG_USB_SL811_HCD is not set
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_WHCI_HCD=y
CONFIG_USB_HWA_HCD=y
CONFIG_USB_HCD_SSB=y
CONFIG_USB_HCD_TEST_MODE=y

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
CONFIG_USB_STORAGE_DEBUG=y
# CONFIG_USB_STORAGE_REALTEK is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
# CONFIG_USB_STORAGE_JUMPSHOT is not set
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_ONETOUCH=y
CONFIG_USB_STORAGE_KARMA=y
CONFIG_USB_STORAGE_CYPRESS_ATACB=y
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
# CONFIG_USB_UAS is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
CONFIG_USBIP_CORE=y
CONFIG_USBIP_VHCI_HCD=y
CONFIG_USBIP_VHCI_HC_PORTS=8
CONFIG_USBIP_VHCI_NR_HCS=1
CONFIG_USBIP_HOST=y
CONFIG_USBIP_DEBUG=y
CONFIG_USB_MUSB_HDRC=y
CONFIG_USB_MUSB_HOST=y

#
# Platform Glue Layer
#

#
# MUSB DMA mode
#
# CONFIG_MUSB_PIO_ONLY is not set
# CONFIG_USB_DWC3 is not set
CONFIG_USB_DWC2=y
CONFIG_USB_DWC2_HOST=y

#
# Gadget/Dual-role mode requires USB Gadget support to be enabled
#
CONFIG_USB_DWC2_PCI=y
# CONFIG_USB_DWC2_DEBUG is not set
# CONFIG_USB_DWC2_TRACK_MISSED_SOFS is not set
# CONFIG_USB_CHIPIDEA is not set
# CONFIG_USB_ISP1760 is not set

#
# USB port drivers
#
CONFIG_USB_USS720=y
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_SIMPLE is not set
CONFIG_USB_SERIAL_AIRCABLE=y
CONFIG_USB_SERIAL_ARK3116=y
CONFIG_USB_SERIAL_BELKIN=y
# CONFIG_USB_SERIAL_CH341 is not set
CONFIG_USB_SERIAL_WHITEHEAT=y
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP210X is not set
CONFIG_USB_SERIAL_CYPRESS_M8=y
CONFIG_USB_SERIAL_EMPEG=y
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
CONFIG_USB_SERIAL_IR=y
CONFIG_USB_SERIAL_EDGEPORT=y
CONFIG_USB_SERIAL_EDGEPORT_TI=y
# CONFIG_USB_SERIAL_F81232 is not set
CONFIG_USB_SERIAL_F8153X=y
CONFIG_USB_SERIAL_GARMIN=y
CONFIG_USB_SERIAL_IPW=y
CONFIG_USB_SERIAL_IUU=y
CONFIG_USB_SERIAL_KEYSPAN_PDA=y
# CONFIG_USB_SERIAL_KEYSPAN is not set
CONFIG_USB_SERIAL_KLSI=y
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
CONFIG_USB_SERIAL_MCT_U232=y
CONFIG_USB_SERIAL_METRO=y
CONFIG_USB_SERIAL_MOS7720=y
# CONFIG_USB_SERIAL_MOS7715_PARPORT is not set
CONFIG_USB_SERIAL_MOS7840=y
# CONFIG_USB_SERIAL_MXUPORT is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
# CONFIG_USB_SERIAL_PL2303 is not set
CONFIG_USB_SERIAL_OTI6858=y
CONFIG_USB_SERIAL_QCAUX=y
CONFIG_USB_SERIAL_QUALCOMM=y
CONFIG_USB_SERIAL_SPCP8X5=y
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
CONFIG_USB_SERIAL_SYMBOL=y
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
CONFIG_USB_SERIAL_XIRCOM=y
CONFIG_USB_SERIAL_WWAN=y
CONFIG_USB_SERIAL_OPTION=y
CONFIG_USB_SERIAL_OMNINET=y
CONFIG_USB_SERIAL_OPTICON=y
CONFIG_USB_SERIAL_XSENS_MT=y
# CONFIG_USB_SERIAL_WISHBONE is not set
# CONFIG_USB_SERIAL_SSU100 is not set
CONFIG_USB_SERIAL_QT2=y
# CONFIG_USB_SERIAL_UPD78F0730 is not set
CONFIG_USB_SERIAL_DEBUG=y

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=y
# CONFIG_USB_SEVSEG is not set
CONFIG_USB_RIO500=y
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
CONFIG_USB_CYTHERM=y
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=y
# CONFIG_USB_APPLEDISPLAY is not set
CONFIG_USB_SISUSBVGA=y
# CONFIG_USB_SISUSBVGA_CON is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=y
CONFIG_USB_EHSET_TEST_FIXTURE=y
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=y
CONFIG_USB_HUB_USB251XB=y
CONFIG_USB_HSIC_USB3503=y
CONFIG_USB_HSIC_USB4604=y
# CONFIG_USB_LINK_LAYER_TEST is not set
CONFIG_UCSI=y
CONFIG_USB_ATM=y
CONFIG_USB_SPEEDTOUCH=y
CONFIG_USB_CXACRU=y
CONFIG_USB_UEAGLEATM=y
# CONFIG_USB_XUSBATM is not set

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_TAHVO_USB is not set
CONFIG_USB_ISP1301=y
# CONFIG_USB_GADGET is not set
# CONFIG_USB_LED_TRIG is not set
CONFIG_USB_ULPI_BUS=y
CONFIG_UWB=y
CONFIG_UWB_HWA=y
CONFIG_UWB_WHCI=y
CONFIG_UWB_I1480U=y
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
CONFIG_PWRSEQ_EMMC=y
CONFIG_PWRSEQ_SIMPLE=y
# CONFIG_MMC_BLOCK is not set
CONFIG_SDIO_UART=y
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_PCI=y
# CONFIG_MMC_RICOH_MMC is not set
CONFIG_MMC_SDHCI_ACPI=y
CONFIG_MMC_SDHCI_PLTFM=y
CONFIG_MMC_SDHCI_OF_ARASAN=y
# CONFIG_MMC_SDHCI_OF_AT91 is not set
CONFIG_MMC_SDHCI_CADENCE=y
CONFIG_MMC_SDHCI_F_SDH30=y
CONFIG_MMC_WBSD=y
CONFIG_MMC_TIFM_SD=y
CONFIG_MMC_CB710=y
CONFIG_MMC_VIA_SDMMC=y
# CONFIG_MMC_VUB300 is not set
CONFIG_MMC_USHC=y
CONFIG_MMC_USDHI6ROL0=y
CONFIG_MMC_REALTEK_PCI=y
CONFIG_MMC_TOSHIBA_PCI=y
CONFIG_MMC_MTK=y
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
# CONFIG_MSPRO_BLOCK is not set
# CONFIG_MS_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
CONFIG_MEMSTICK_R592=y
CONFIG_MEMSTICK_REALTEK_PCI=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
CONFIG_LEDS_CLASS_FLASH=y
# CONFIG_LEDS_BRIGHTNESS_HW_CHANGED is not set

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
CONFIG_LEDS_AAT1290=y
# CONFIG_LEDS_BCM6328 is not set
# CONFIG_LEDS_BCM6358 is not set
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3533=y
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP3952 is not set
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
# CONFIG_LEDS_LP8860 is not set
CONFIG_LEDS_CLEVO_MAIL=y
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_WM8350=y
# CONFIG_LEDS_DA903X is not set
CONFIG_LEDS_REGULATOR=y
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=y
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_TLC591XX=y
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_MENF21BMC=y
# CONFIG_LEDS_KTD2692 is not set
CONFIG_LEDS_IS31FL319X=y
# CONFIG_LEDS_IS31FL32XX is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=y
# CONFIG_LEDS_SYSCON is not set
# CONFIG_LEDS_MLXCPLD is not set
CONFIG_LEDS_USER=y
# CONFIG_LEDS_NIC78BX is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
CONFIG_LEDS_TRIGGER_MTD=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
CONFIG_LEDS_TRIGGER_CAMERA=y
CONFIG_LEDS_TRIGGER_PANIC=y
CONFIG_ACCESSIBILITY=y
CONFIG_A11Y_BRAILLE_CONSOLE=y
CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_USER_MAD=y
CONFIG_INFINIBAND_USER_ACCESS=y
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ON_DEMAND_PAGING=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_ADDR_TRANS_CONFIGFS=y
CONFIG_INFINIBAND_MTHCA=y
CONFIG_INFINIBAND_MTHCA_DEBUG=y
# CONFIG_INFINIBAND_QIB is not set
# CONFIG_INFINIBAND_CXGB4 is not set
CONFIG_MLX4_INFINIBAND=y
CONFIG_MLX5_INFINIBAND=y
# CONFIG_INFINIBAND_NES is not set
CONFIG_INFINIBAND_OCRDMA=y
CONFIG_INFINIBAND_VMWARE_PVRDMA=y
CONFIG_INFINIBAND_IPOIB=y
# CONFIG_INFINIBAND_IPOIB_CM is not set
CONFIG_INFINIBAND_IPOIB_DEBUG=y
# CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
CONFIG_INFINIBAND_SRP=y
CONFIG_INFINIBAND_SRPT=y
CONFIG_INFINIBAND_ISER=y
CONFIG_INFINIBAND_ISERT=y
CONFIG_INFINIBAND_RDMAVT=y
CONFIG_RDMA_RXE=y
CONFIG_INFINIBAND_HFI1=y
CONFIG_HFI1_DEBUG_SDMA_ORDER=y
# CONFIG_HFI1_VERBS_31BIT_PSN is not set
# CONFIG_SDMA_VERBOSITY is not set
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=y
CONFIG_EDAC_E752X=y
CONFIG_EDAC_I82975X=y
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
CONFIG_EDAC_IE31200=y
CONFIG_EDAC_X38=y
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_SYSTOHC_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
# CONFIG_RTC_INTF_PROC is not set
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM860X=y
CONFIG_RTC_DRV_ABB5ZES3=y
CONFIG_RTC_DRV_ABX80X=y
CONFIG_RTC_DRV_AS3722=y
# CONFIG_RTC_DRV_DS1307 is not set
CONFIG_RTC_DRV_DS1374=y
CONFIG_RTC_DRV_DS1374_WDT=y
CONFIG_RTC_DRV_DS1672=y
CONFIG_RTC_DRV_HYM8563=y
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_MAX8907=y
CONFIG_RTC_DRV_MAX8925=y
CONFIG_RTC_DRV_RK808=y
CONFIG_RTC_DRV_RS5C372=y
# CONFIG_RTC_DRV_ISL1208 is not set
CONFIG_RTC_DRV_ISL12022=y
CONFIG_RTC_DRV_X1205=y
# CONFIG_RTC_DRV_PCF8523 is not set
CONFIG_RTC_DRV_PCF85063=y
CONFIG_RTC_DRV_PCF8563=y
CONFIG_RTC_DRV_PCF8583=y
CONFIG_RTC_DRV_M41T80=y
CONFIG_RTC_DRV_M41T80_WDT=y
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_RC5T583=y
CONFIG_RTC_DRV_S35390A=y
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8010 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
CONFIG_RTC_DRV_EM3027=y
CONFIG_RTC_DRV_RV8803=y

#
# SPI RTC drivers
#
CONFIG_RTC_I2C_AND_SPI=y

#
# SPI and I2C RTC drivers
#
# CONFIG_RTC_DRV_DS3232 is not set
CONFIG_RTC_DRV_PCF2127=y
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
CONFIG_RTC_DRV_VRTC=y
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
# CONFIG_RTC_DRV_DS1685_FAMILY is not set
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_DS2404=y
CONFIG_RTC_DRV_DA9063=y
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=y
# CONFIG_RTC_DRV_WM8350 is not set
CONFIG_RTC_DRV_AB3100=y
CONFIG_RTC_DRV_ZYNQMP=y

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_SNVS is not set
CONFIG_RTC_DRV_R7301=y

#
# HID Sensor RTC drivers
#
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=y
CONFIG_DMA_ACPI=y
CONFIG_DMA_OF=y
# CONFIG_FSL_EDMA is not set
CONFIG_INTEL_IDMA64=y
CONFIG_INTEL_IOATDMA=y
# CONFIG_INTEL_MIC_X100_DMA is not set
# CONFIG_QCOM_HIDMA_MGMT is not set
CONFIG_QCOM_HIDMA=y
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=y
CONFIG_DW_DMAC_PCI=y
CONFIG_HSU_DMA=y
CONFIG_HSU_DMA_PCI=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=y
CONFIG_DMA_ENGINE_RAID=y

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
# CONFIG_SW_SYNC is not set
CONFIG_DCA=y
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
CONFIG_UIO_CIF=y
CONFIG_UIO_PDRV_GENIRQ=y
# CONFIG_UIO_DMEM_GENIRQ is not set
CONFIG_UIO_AEC=y
CONFIG_UIO_SERCOS3=y
CONFIG_UIO_PCI_GENERIC=y
# CONFIG_UIO_NETX is not set
CONFIG_UIO_PRUSS=y
CONFIG_UIO_MF624=y
CONFIG_UIO_HV_GENERIC=y
CONFIG_IRQ_BYPASS_MANAGER=y
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_PCI_LEGACY=y
CONFIG_VIRTIO_BALLOON=y
# CONFIG_VIRTIO_INPUT is not set
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=y
CONFIG_HYPERV_UTILS=y
# CONFIG_HYPERV_BALLOON is not set
CONFIG_STAGING=y
CONFIG_R8712U=y
CONFIG_RTS5208=y
# CONFIG_FB_SM750 is not set
# CONFIG_FB_XGI is not set

#
# Speakup console speech
#
CONFIG_SPEAKUP=y
CONFIG_SPEAKUP_SYNTH_ACNTSA=y
CONFIG_SPEAKUP_SYNTH_APOLLO=y
CONFIG_SPEAKUP_SYNTH_AUDPTR=y
CONFIG_SPEAKUP_SYNTH_BNS=y
# CONFIG_SPEAKUP_SYNTH_DECTLK is not set
# CONFIG_SPEAKUP_SYNTH_DECEXT is not set
CONFIG_SPEAKUP_SYNTH_LTLK=y
# CONFIG_SPEAKUP_SYNTH_SOFT is not set
CONFIG_SPEAKUP_SYNTH_SPKOUT=y
CONFIG_SPEAKUP_SYNTH_TXPRT=y
CONFIG_SPEAKUP_SYNTH_DUMMY=y
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
CONFIG_ASHMEM=y
# CONFIG_ANDROID_LOW_MEMORY_KILLER is not set
# CONFIG_ION is not set
CONFIG_STAGING_BOARD=y
CONFIG_FIREWIRE_SERIAL=y
CONFIG_FWTTY_MAX_TOTAL_PORTS=64
CONFIG_FWTTY_MAX_CARD_PORTS=32
# CONFIG_DGNC is not set
# CONFIG_GS_FPGABOOT is not set
CONFIG_CRYPTO_SKEIN=y
CONFIG_UNISYSSPAR=y
# CONFIG_UNISYS_VISORBUS is not set
CONFIG_COMMON_CLK_XLNX_CLKWZRD=y
CONFIG_MOST=y
CONFIG_MOSTCORE=y
CONFIG_AIM_CDEV=y
CONFIG_AIM_NETWORK=y
CONFIG_AIM_SOUND=y
CONFIG_AIM_V4L2=y
CONFIG_HDM_DIM2=y
CONFIG_HDM_I2C=y
CONFIG_HDM_USB=y
# CONFIG_KS7010 is not set
CONFIG_GREYBUS=y
# CONFIG_GREYBUS_ES2 is not set
CONFIG_GREYBUS_AUDIO=y
# CONFIG_GREYBUS_BOOTROM is not set
# CONFIG_GREYBUS_HID is not set
CONFIG_GREYBUS_LIGHT=y
CONFIG_GREYBUS_LOG=y
CONFIG_GREYBUS_LOOPBACK=y
CONFIG_GREYBUS_POWER=y
CONFIG_GREYBUS_RAW=y
CONFIG_GREYBUS_VIBRATOR=y
CONFIG_GREYBUS_BRIDGED_PHY=y
# CONFIG_GREYBUS_GPIO is not set
CONFIG_GREYBUS_I2C=y
CONFIG_GREYBUS_SDIO=y
CONFIG_GREYBUS_UART=y
# CONFIG_GREYBUS_USB is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
CONFIG_ASUS_LAPTOP=y
CONFIG_DELL_SMBIOS=y
CONFIG_DELL_LAPTOP=y
CONFIG_DELL_SMO8800=y
CONFIG_FUJITSU_LAPTOP=y
CONFIG_FUJITSU_LAPTOP_DEBUG=y
# CONFIG_FUJITSU_TABLET is not set
CONFIG_HP_ACCEL=y
CONFIG_HP_WIRELESS=y
CONFIG_PANASONIC_LAPTOP=y
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
CONFIG_INTEL_MENLOW=y
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ASUS_WIRELESS is not set
# CONFIG_ACPI_WMI is not set
CONFIG_TOPSTAR_LAPTOP=y
# CONFIG_TOSHIBA_BT_RFKILL is not set
CONFIG_TOSHIBA_HAPS=y
# CONFIG_ACPI_CMPC is not set
CONFIG_INTEL_HID_EVENT=y
# CONFIG_INTEL_VBTN is not set
CONFIG_INTEL_SCU_IPC=y
CONFIG_INTEL_SCU_IPC_UTIL=y
# CONFIG_INTEL_MID_POWER_BUTTON is not set
# CONFIG_INTEL_MFLD_THERMAL is not set
CONFIG_INTEL_IPS=y
# CONFIG_INTEL_PMC_CORE is not set
CONFIG_IBM_RTL=y
CONFIG_SAMSUNG_LAPTOP=y
CONFIG_SAMSUNG_Q10=y
CONFIG_APPLE_GMUX=y
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
CONFIG_PVPANIC=y
# CONFIG_INTEL_PMC_IPC is not set
# CONFIG_SURFACE_PRO3_BUTTON is not set
CONFIG_INTEL_PUNIT_IPC=y
CONFIG_MLX_PLATFORM=y
CONFIG_MLX_CPLD_PLATFORM=y
# CONFIG_INTEL_TURBO_MAX_3 is not set
# CONFIG_SILEAD_DMI is not set
CONFIG_PMC_ATOM=y
CONFIG_CHROME_PLATFORMS=y
# CONFIG_CHROMEOS_LAPTOP is not set
CONFIG_CHROMEOS_PSTORE=y
CONFIG_CROS_EC_CHARDEV=y
# CONFIG_CROS_EC_LPC is not set
CONFIG_CROS_EC_PROTO=y
# CONFIG_CROS_KBD_LED_BACKLIGHT is not set
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
CONFIG_COMMON_CLK_RK808=y
CONFIG_COMMON_CLK_SI5351=y
# CONFIG_COMMON_CLK_SI514 is not set
# CONFIG_COMMON_CLK_SI570 is not set
# CONFIG_COMMON_CLK_CDCE706 is not set
CONFIG_COMMON_CLK_CDCE925=y
CONFIG_COMMON_CLK_CS2000_CP=y
# CONFIG_COMMON_CLK_NXP is not set
# CONFIG_COMMON_CLK_PXA is not set
# CONFIG_COMMON_CLK_PIC32 is not set
CONFIG_COMMON_CLK_VC5=y

#
# Hardware Spinlock drivers
#

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_DW_APB_TIMER=y
# CONFIG_ATMEL_PIT is not set
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
CONFIG_MAILBOX=y
# CONFIG_PLATFORM_MHU is not set
CONFIG_PCC=y
CONFIG_ALTERA_MBOX=y
CONFIG_MAILBOX_TEST=y
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y

#
# Rpmsg drivers
#

#
# SOC (System On Chip) specific Drivers
#

#
# Broadcom SoC drivers
#
# CONFIG_SUNXI_SRAM is not set
# CONFIG_SOC_TI is not set
CONFIG_SOC_ZTE=y
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
# CONFIG_DEVFREQ_GOV_USERSPACE is not set
# CONFIG_DEVFREQ_GOV_PASSIVE is not set

#
# DEVFREQ Drivers
#
# CONFIG_PM_DEVFREQ_EVENT is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_AXP288 is not set
# CONFIG_EXTCON_GPIO is not set
CONFIG_EXTCON_INTEL_INT3496=y
CONFIG_EXTCON_MAX14577=y
CONFIG_EXTCON_MAX3355=y
CONFIG_EXTCON_MAX77843=y
CONFIG_EXTCON_QCOM_SPMI_MISC=y
CONFIG_EXTCON_RT8973A=y
CONFIG_EXTCON_SM5502=y
CONFIG_EXTCON_USB_GPIO=y
CONFIG_MEMORY=y
# CONFIG_IIO is not set
CONFIG_NTB=y
CONFIG_NTB_AMD=y
CONFIG_NTB_INTEL=y
CONFIG_NTB_PINGPONG=y
CONFIG_NTB_TOOL=y
CONFIG_NTB_PERF=y
# CONFIG_NTB_TRANSPORT is not set
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=y
CONFIG_VME_TSI148=y
# CONFIG_VME_FAKE is not set

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=y

#
# VME Device Drivers
#
CONFIG_VME_USER=y
# CONFIG_VME_PIO2 is not set
# CONFIG_PWM is not set
CONFIG_IRQCHIP=y
CONFIG_ARM_GIC_MAX_NR=1
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
CONFIG_SERIAL_IPOCTAL=y
CONFIG_RESET_CONTROLLER=y
# CONFIG_RESET_ATH79 is not set
# CONFIG_RESET_BERLIN is not set
# CONFIG_RESET_LPC18XX is not set
# CONFIG_RESET_MESON is not set
# CONFIG_RESET_PISTACHIO is not set
# CONFIG_RESET_SOCFPGA is not set
# CONFIG_RESET_STM32 is not set
# CONFIG_RESET_SUNXI is not set
# CONFIG_TI_SYSCON_RESET is not set
# CONFIG_RESET_ZYNQ is not set
# CONFIG_RESET_TEGRA_BPMP is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_PHY_PXA_28NM_HSIC=y
CONFIG_PHY_PXA_28NM_USB2=y
CONFIG_BCM_KONA_USB2_PHY=y
CONFIG_PHY_SAMSUNG_USB2=y
# CONFIG_PHY_EXYNOS4210_USB2 is not set
# CONFIG_PHY_EXYNOS4X12_USB2 is not set
# CONFIG_PHY_EXYNOS5250_USB2 is not set
# CONFIG_PHY_QCOM_USB_HS is not set
CONFIG_PHY_QCOM_USB_HSIC=y
CONFIG_PHY_TUSB1210=y
# CONFIG_POWERCAP is not set
CONFIG_MCB=y
CONFIG_MCB_PCI=y
CONFIG_MCB_LPC=y

#
# Performance monitor support
#
CONFIG_RAS=y
CONFIG_THUNDERBOLT=y

#
# Android
#
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
CONFIG_ANDROID_BINDER_DEVICES="binder"
CONFIG_LIBNVDIMM=y
# CONFIG_BLK_DEV_PMEM is not set
CONFIG_ND_BLK=y
CONFIG_ND_CLAIM=y
CONFIG_ND_BTT=y
CONFIG_BTT=y
# CONFIG_NVMEM is not set
# CONFIG_STM is not set
# CONFIG_INTEL_TH is not set

#
# FPGA Configuration Support
#
# CONFIG_FPGA is not set

#
# FSI support
#
CONFIG_FSI=y

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=y
CONFIG_FW_CFG_SYSFS=y
CONFIG_FW_CFG_SYSFS_CMDLINE=y
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
# CONFIG_GOOGLE_SMI is not set
# CONFIG_GOOGLE_MEMCONSOLE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
CONFIG_EFI_ESRT=y
# CONFIG_EFI_RUNTIME_MAP is not set
# CONFIG_EFI_FAKE_MEMMAP is not set
CONFIG_EFI_RUNTIME_WRAPPERS=y
CONFIG_EFI_BOOTLOADER_CONTROL=y
CONFIG_EFI_CAPSULE_LOADER=y
CONFIG_EFI_TEST=y
# CONFIG_EFI_DEV_PATH_PARSER is not set

#
# Tegra firmware driver
#

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_FS_IOMAP=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
# CONFIG_EXT2_FS_POSIX_ACL is not set
# CONFIG_EXT2_FS_SECURITY is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_FS_POSIX_ACL is not set
# CONFIG_EXT3_FS_SECURITY is not set
CONFIG_EXT4_FS=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_ENCRYPTION is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
# CONFIG_JFS_SECURITY is not set
# CONFIG_JFS_DEBUG is not set
CONFIG_JFS_STATISTICS=y
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_POSIX_ACL is not set
CONFIG_XFS_RT=y
CONFIG_XFS_WARN=y
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=y
# CONFIG_GFS2_FS_LOCKING_DLM is not set
CONFIG_OCFS2_FS=y
# CONFIG_OCFS2_FS_O2CB is not set
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=y
# CONFIG_OCFS2_FS_STATS is not set
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
CONFIG_BTRFS_DEBUG=y
CONFIG_BTRFS_ASSERT=y
CONFIG_NILFS2_FS=y
# CONFIG_F2FS_FS is not set
# CONFIG_FS_DAX is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_EXPORTFS_BLOCK_OPS is not set
CONFIG_FILE_LOCKING=y
CONFIG_MANDATORY_FILE_LOCKING=y
CONFIG_FS_ENCRYPTION=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
CONFIG_CUSE=y
# CONFIG_OVERLAY_FS is not set

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_STATS is not set
CONFIG_FSCACHE_HISTOGRAM=y
CONFIG_FSCACHE_DEBUG=y
CONFIG_FSCACHE_OBJECT_LIST=y
CONFIG_CACHEFILES=y
# CONFIG_CACHEFILES_DEBUG is not set
CONFIG_CACHEFILES_HISTOGRAM=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_FAT_DEFAULT_UTF8=y
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
# CONFIG_PROC_VMCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
# CONFIG_PROC_CHILDREN is not set
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_ARCH_HAS_GIGANTIC_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_EFIVAR_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V2=y
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
CONFIG_NFS_V4=y
# CONFIG_NFS_SWAP is not set
# CONFIG_NFS_V4_1 is not set
# CONFIG_ROOT_NFS is not set
# CONFIG_NFS_FSCACHE is not set
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
# CONFIG_NFSD is not set
CONFIG_GRACE_PERIOD=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_RPCSEC_GSS_KRB5=y
# CONFIG_SUNRPC_DEBUG is not set
CONFIG_SUNRPC_XPRT_RDMA=y
CONFIG_CEPH_FS=y
CONFIG_CEPH_FSCACHE=y
CONFIG_CEPH_FS_POSIX_ACL=y
CONFIG_CIFS=y
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
CONFIG_CIFS_WEAK_PW_HASH=y
# CONFIG_CIFS_UPCALL is not set
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
CONFIG_CIFS_ACL=y
# CONFIG_CIFS_DEBUG is not set
# CONFIG_CIFS_DFS_UPCALL is not set
CONFIG_CIFS_SMB2=y
CONFIG_CIFS_SMB311=y
CONFIG_CIFS_FSCACHE=y
CONFIG_NCP_FS=y
# CONFIG_NCPFS_PACKET_SIGNING is not set
# CONFIG_NCPFS_IOCTL_LOCKING is not set
# CONFIG_NCPFS_STRONG is not set
CONFIG_NCPFS_NFS_NS=y
# CONFIG_NCPFS_OS2_NS is not set
# CONFIG_NCPFS_SMALLDOS is not set
CONFIG_NCPFS_NLS=y
CONFIG_NCPFS_EXTRAS=y
CONFIG_CODA_FS=y
# CONFIG_AFS_FS is not set
# CONFIG_9P_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=y
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
# CONFIG_NLS_UTF8 is not set
CONFIG_DLM=y
CONFIG_DLM_DEBUG=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
# CONFIG_BOOT_PRINTK_DELAY is not set
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
# CONFIG_PAGE_OWNER is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_STACK_VALIDATION is not set
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
# CONFIG_MAGIC_SYSRQ_SERIAL is not set
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_PAGE_EXTENSION is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_PAGE_POISONING is not set
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
# CONFIG_DEBUG_OBJECTS_WORK is not set
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_VMACACHE is not set
CONFIG_DEBUG_VM_RB=y
# CONFIG_DEBUG_VM_PGFLAGS is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_ARCH_HAS_KCOV=y
# CONFIG_KCOV is not set
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_WQ_WATCHDOG=y
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHED_INFO=y
CONFIG_SCHEDSTATS=y
CONFIG_SCHED_STACK_END_CHECK=y
# CONFIG_DEBUG_TIMEKEEPING is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
CONFIG_WW_MUTEX_SELFTEST=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_PI_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_PERF_TEST is not set
CONFIG_RCU_TORTURE_TEST=y
CONFIG_RCU_TORTURE_TEST_SLOW_PREINIT=y
CONFIG_RCU_TORTURE_TEST_SLOW_PREINIT_DELAY=3
# CONFIG_RCU_TORTURE_TEST_SLOW_INIT is not set
# CONFIG_RCU_TORTURE_TEST_SLOW_CLEANUP is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_TRACE=y
CONFIG_RCU_EQS_DEBUG=y
CONFIG_DEBUG_WQ_FORCE_RR_CPU=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_CPU_HOTPLUG_STATE_CONTROL is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
CONFIG_OF_RECONFIG_NOTIFIER_ERROR_INJECT=y
# CONFIG_NETDEV_NOTIFIER_ERROR_INJECT is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
CONFIG_LKDTM=y
# CONFIG_TEST_LIST_SORT is not set
CONFIG_TEST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_ASYNC_RAID6_TEST=y
CONFIG_TEST_HEXDUMP=y
CONFIG_TEST_STRING_HELPERS=y
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_TEST_PRINTF is not set
CONFIG_TEST_BITMAP=y
CONFIG_TEST_UUID=y
CONFIG_TEST_RHASHTABLE=y
# CONFIG_TEST_HASH is not set
CONFIG_TEST_PARMAN=y
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_TEST_FIRMWARE=y
CONFIG_TEST_UDELAY=y
# CONFIG_MEMTEST is not set
CONFIG_BUG_ON_DATA_CORRUPTION=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
# CONFIG_ARCH_WANTS_UBSAN_NO_NULL is not set
# CONFIG_UBSAN is not set
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_EARLY_PRINTK_EFI=y
CONFIG_X86_PTDUMP_CORE=y
CONFIG_X86_PTDUMP=y
# CONFIG_EFI_PGT_DUMP is not set
# CONFIG_DEBUG_WX is not set
CONFIG_DOUBLEFAULT=y
CONFIG_DEBUG_TLBFLUSH=y
# CONFIG_IOMMU_DEBUG is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_ENTRY is not set
CONFIG_DEBUG_NMI_SELFTEST=y
# CONFIG_X86_DEBUG_FPU is not set
CONFIG_PUNIT_ATOM_DEBUG=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
# CONFIG_BIG_KEYS is not set
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEY_DH_OPERATIONS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
CONFIG_HAVE_ARCH_HARDENED_USERCOPY=y
# CONFIG_HARDENED_USERCOPY is not set
# CONFIG_STATIC_USERMODEHELPER is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_ASYNC_PQ=y
CONFIG_ASYNC_RAID6_RECOV=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_RNG_DEFAULT=y
CONFIG_CRYPTO_AKCIPHER2=y
CONFIG_CRYPTO_AKCIPHER=y
CONFIG_CRYPTO_KPP2=y
CONFIG_CRYPTO_KPP=y
CONFIG_CRYPTO_ACOMP2=y
CONFIG_CRYPTO_RSA=y
CONFIG_CRYPTO_DH=y
CONFIG_CRYPTO_ECDH=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_NULL2=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_MCRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_SIMD=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
# CONFIG_CRYPTO_CHACHA20POLY1305 is not set
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_ECHAINIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y
CONFIG_CRYPTO_KEYWRAP=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
# CONFIG_CRYPTO_CRCT10DIF_PCLMUL is not set
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_POLY1305=y
# CONFIG_CRYPTO_POLY1305_X86_64 is not set
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
CONFIG_CRYPTO_SHA512_SSSE3=y
# CONFIG_CRYPTO_SHA1_MB is not set
# CONFIG_CRYPTO_SHA256_MB is not set
CONFIG_CRYPTO_SHA512_MB=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_SHA3=y
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_TI is not set
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_DES3_EDE_X86_64=y
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=y
CONFIG_CRYPTO_CHACHA20=y
# CONFIG_CRYPTO_CHACHA20_X86_64 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_LZO is not set
CONFIG_CRYPTO_842=y
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
CONFIG_CRYPTO_DRBG_HASH=y
CONFIG_CRYPTO_DRBG_CTR=y
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_USER_API_RNG=y
# CONFIG_CRYPTO_USER_API_AEAD is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_DESC is not set
# CONFIG_CRYPTO_DEV_CCP is not set
CONFIG_CRYPTO_DEV_QAT=y
# CONFIG_CRYPTO_DEV_QAT_DH895xCC is not set
# CONFIG_CRYPTO_DEV_QAT_C3XXX is not set
CONFIG_CRYPTO_DEV_QAT_C62X=y
CONFIG_CRYPTO_DEV_QAT_DH895xCCVF=y
CONFIG_CRYPTO_DEV_QAT_C3XXXVF=y
CONFIG_CRYPTO_DEV_QAT_C62XVF=y
CONFIG_CRYPTO_DEV_CHELSIO=y
# CONFIG_CRYPTO_DEV_VIRTIO is not set
# CONFIG_ASYMMETRIC_KEY_TYPE is not set

#
# Certificates for signature checking
#
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQFD=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y
CONFIG_KVM_COMPAT=y
CONFIG_HAVE_KVM_IRQ_BYPASS=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
# CONFIG_KVM_INTEL is not set
CONFIG_KVM_AMD=y
CONFIG_VHOST_NET=y
CONFIG_VHOST_VSOCK=y
CONFIG_VHOST=y
CONFIG_VHOST_CROSS_ENDIAN_LEGACY=y
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
# CONFIG_HAVE_ARCH_BITREVERSE is not set
CONFIG_RATIONAL=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
CONFIG_RANDOM32_SELFTEST=y
CONFIG_842_COMPRESS=y
CONFIG_842_DECOMPRESS=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_BTREE=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
# CONFIG_DMA_NOOP_OPS is not set
CONFIG_DMA_VIRT_OPS=y
CONFIG_CHECK_SIGNATURE=y
# CONFIG_CPUMASK_OFFSTACK is not set
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_IRQ_POLL=y
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
CONFIG_FONT_SUPPORT=y
CONFIG_FONT_8x16=y
CONFIG_FONT_AUTOSELECT=y
# CONFIG_SG_SPLIT is not set
CONFIG_SG_POOL=y
CONFIG_ARCH_HAS_SG_CHAIN=y
CONFIG_ARCH_HAS_PMEM_API=y
CONFIG_ARCH_HAS_MMIO_FLUSH=y
CONFIG_SBITMAP=y
CONFIG_PARMAN=y

--=_58fa8fe6.KGFv/UXliio9jXxjVQFvebtQ9aGO5BcnYb6+L2i99TruwxkY--
