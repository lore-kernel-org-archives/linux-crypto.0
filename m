From: Anatoly Pugachev <matorola@gmail.com>
Subject: booting sun sparc T5120 with "nosmp" kernel 4.5.4 causes OOPS in
 n2_crypto module
Date: Tue, 24 May 2016 15:04:26 +0300
Message-ID: <CADxRZqyKYV=Y7P24uj-moc11qhd6To=i2jkXEu36=7vYFTvRqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary=001a114db5cec7abce0533955bcf
Cc: debian-sparc <debian-sparc@lists.debian.org>, linux-crypto@vger.kernel.org
To: sparclinux@vger.kernel.org
Return-path: <bounce-debian-sparc=debian-sparc=m.gmane.org@lists.debian.org>
Resent-Message-ID: <B_HFautX-PO.A.ryF.hNERXB@bendel>
List-URL: <https://lists.debian.org/debian-sparc/>
List-Post: <mailto:debian-sparc@lists.debian.org>
List-Help: <mailto:debian-sparc-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-sparc-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-sparc-request@lists.debian.org?subject=unsubscribe>
List-Archive: https://lists.debian.org/msgid-search/CADxRZqyKYV=Y7P24uj-moc11qhd6To=i2jkXEu36=7vYFTvRqA@mail.gmail.com
List-Id: linux-crypto.vger.kernel.org

--001a114db5cec7abce0533955bcf
Content-Type: text/plain; charset=UTF-8

Hello!

Tried to boot T5120 with nosmp kernel option, gives OOPS in n2_crypto
module:


May 24 13:11:48 nvg5120 kernel: Kernel command line:
root=/dev/mapper/vg1-root ro nosmp
...
May 24 13:11:48 nvg5120 kernel: Loading compiled-in X.509 certificates
May 24 13:11:48 nvg5120 kernel: Kernel unaligned access at TPC[739430]
mpi_read_buffer+0xd0/0x120
May 24 13:11:48 nvg5120 kernel: Loaded X.509 cert 'Debian Project: Ben
Hutchings: 008a018dca80932630'
May 24 13:11:48 nvg5120 kernel: rtc-sun4v rtc-sun4v: setting system clock
to 2016-05-24 10:11:26 UTC (1464084686)
May 24 13:11:48 nvg5120 kernel: aes_sparc64: module verification failed:
signature and/or required key missing - tainting kernel
May 24 13:11:48 nvg5120 kernel: aes_sparc64: sparc64 aes opcodes not
available.
...
May 24 13:11:50 nvg5120 kernel: sha256_sparc64: sparc64 sha256 opcode not
available.
May 24 13:11:50 nvg5120 kernel: n2rng.c:v0.2 (July 27, 2011)
May 24 13:11:50 nvg5120 kernel: n2rng f0286a1c: Registered RNG HVAPI major
2 minor 0
May 24 13:11:50 nvg5120 kernel: n2rng f0286a1c: Found single-unit RNG,
units: 1
May 24 13:11:50 nvg5120 kernel: n2rng f0286a1c: Selftest passed on unit 0
May 24 13:11:50 nvg5120 kernel: n2rng f0286a1c: RNG ready
May 24 13:11:50 nvg5120 kernel: des_sparc64: sparc64 des opcodes not
available.
May 24 13:11:50 nvg5120 kernel: des_sparc64: sparc64 des opcodes not
available.
May 24 13:11:50 nvg5120 kernel: des_sparc64: sparc64 des opcodes not
available.
May 24 13:11:50 nvg5120 kernel: sha1_sparc64: sparc64 sha1 opcode not
available.
May 24 13:11:50 nvg5120 kernel: des_sparc64: sparc64 des opcodes not
available.
May 24 13:11:50 nvg5120 kernel: n2_crypto: n2_crypto.c:v0.2 (July 28, 2011)
May 24 13:11:50 nvg5120 kernel: n2_crypto: Found N2CP at
/virtual-devices@100/n2cp@7
May 24 13:11:50 nvg5120 kernel: n2_crypto: Registered NCS HVAPI version 2.0
May 24 13:11:50 nvg5120 kernel: genirq: Flags mismatch irq 1. 00000000
(cwq-0) vs. 00000000 (cwq-0)
May 24 13:11:50 nvg5120 kernel: ------------[ cut here ]------------
May 24 13:11:50 nvg5120 kernel: WARNING: CPU: 0 PID: 260 at
/build/linux-c06pcb/linux-4.5.4/kernel/irq/manage.c:1449
__free_irq+0xac/0x2a0()
May 24 13:11:50 nvg5120 kernel: Trying to free already-free IRQ 1
May 24 13:11:50 nvg5120 kernel: Modules linked in: n2_crypto(E+) n2_rng(E+)
sha512_sparc64(E+) rng_core(E) des_generic(E) autofs4(E) ext4(E) ecb(E)
May 24 13:11:50 nvg5120 kernel: CPU: 0 PID: 260 Comm: systemd-udevd
Tainted: G            E   4.5.0-2-sparc64-smp #1 Debian 4.5.4-1
May 24 13:11:50 nvg5120 kernel: Call Trace:
May 24 13:11:50 nvg5120 kernel:  [00000000004669d0]
warn_slowpath_common+0x70/0xc0
May 24 13:11:50 nvg5120 kernel:  [0000000000466a50]
warn_slowpath_fmt+0x30/0x40
May 24 13:11:50 nvg5120 kernel:  [00000000004bdd0c] __free_irq+0xac/0x2a0
May 24 13:11:50 nvg5120 kernel:  [00000000004bdfa0] free_irq+0x40/0x80
May 24 13:11:50 nvg5120 kernel:  [0000000010aae24c]
spu_list_destroy+0xec/0x100 [n2_crypto]
May 24 13:11:50 nvg5120 kernel:  [0000000010aafc98]
spu_mdesc_scan+0x298/0x4a0 [n2_crypto]
May 24 13:11:50 nvg5120 kernel:  [0000000010ab0204]
n2_crypto_probe+0x1a4/0x680 [n2_crypto]
May 24 13:11:50 nvg5120 kernel:  [00000000007c95f4]
platform_drv_probe+0x34/0xc0
May 24 13:11:50 nvg5120 kernel:  [00000000007c708c]
driver_probe_device+0x24c/0x460
May 24 13:11:50 nvg5120 kernel:  [00000000007c7328]
__driver_attach+0x88/0xa0
May 24 13:11:50 nvg5120 kernel:  [00000000007c497c]
bus_for_each_dev+0x5c/0xa0
May 24 13:11:50 nvg5120 kernel:  [00000000007c669c] driver_attach+0x1c/0x40
May 24 13:11:50 nvg5120 kernel:  [00000000007c60b0]
bus_add_driver+0x1f0/0x2a0
May 24 13:11:50 nvg5120 kernel:  [00000000007c7db4]
driver_register+0x74/0x120
May 24 13:11:50 nvg5120 kernel:  [00000000007c97c4]
__platform_register_drivers+0x64/0x160
May 24 13:11:50 nvg5120 kernel:  [0000000010ab6014] n2_init+0x14/0x24
[n2_crypto]
May 24 13:11:50 nvg5120 kernel: ---[ end trace 7aa1f0163177edff ]---
May 24 13:11:50 nvg5120 kernel: camellia_sparc64: sparc64 camellia opcodes
not available.


Full boot logs, "nosmp" and usual (smp) are in [1].

1. https://bugzilla.kernel.org/show_bug.cgi?id=118831

--001a114db5cec7abce0533955bcf
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div>Hello!<br><br></div>Tried to boot T5120 with nos=
mp kernel option, gives OOPS in n2_crypto module:<br><br><br>May 24 13:11:4=
8 nvg5120 kernel: Kernel command line: root=3D/dev/mapper/vg1-root ro nosmp=
<br>...<br>May 24 13:11:48 nvg5120 kernel: Loading compiled-in X.509 certif=
icates<br>May 24 13:11:48 nvg5120 kernel: Kernel unaligned access at TPC[73=
9430] mpi_read_buffer+0xd0/0x120<br>May 24 13:11:48 nvg5120 kernel: Loaded =
X.509 cert &#39;Debian Project: Ben Hutchings: 008a018dca80932630&#39;<br>M=
ay 24 13:11:48 nvg5120 kernel: rtc-sun4v rtc-sun4v: setting system clock to=
 2016-05-24 10:11:26 UTC (1464084686)<br>May 24 13:11:48 nvg5120 kernel: ae=
s_sparc64: module verification failed: signature and/or required key missin=
g - tainting kernel<br>May 24 13:11:48 nvg5120 kernel: aes_sparc64: sparc64=
 aes opcodes not available.<br>...<br>May 24 13:11:50 nvg5120 kernel: sha25=
6_sparc64: sparc64 sha256 opcode not available.<br>May 24 13:11:50 nvg5120 =
kernel: n2rng.c:v0.2 (July 27, 2011)<br>May 24 13:11:50 nvg5120 kernel: n2r=
ng f0286a1c: Registered RNG HVAPI major 2 minor 0<br>May 24 13:11:50 nvg512=
0 kernel: n2rng f0286a1c: Found single-unit RNG, units: 1<br>May 24 13:11:5=
0 nvg5120 kernel: n2rng f0286a1c: Selftest passed on unit 0<br>May 24 13:11=
:50 nvg5120 kernel: n2rng f0286a1c: RNG ready<br>May 24 13:11:50 nvg5120 ke=
rnel: des_sparc64: sparc64 des opcodes not available.<br>May 24 13:11:50 nv=
g5120 kernel: des_sparc64: sparc64 des opcodes not available.<br>May 24 13:=
11:50 nvg5120 kernel: des_sparc64: sparc64 des opcodes not available.<br>Ma=
y 24 13:11:50 nvg5120 kernel: sha1_sparc64: sparc64 sha1 opcode not availab=
le.<br>May 24 13:11:50 nvg5120 kernel: des_sparc64: sparc64 des opcodes not=
 available.<br>May 24 13:11:50 nvg5120 kernel: n2_crypto: n2_crypto.c:v0.2 =
(July 28, 2011)<br>May 24 13:11:50 nvg5120 kernel: n2_crypto: Found N2CP at=
 /virtual-devices@100/n2cp@7<br>May 24 13:11:50 nvg5120 kernel: n2_crypto: =
Registered NCS HVAPI version 2.0<br>May 24 13:11:50 nvg5120 kernel: genirq:=
 Flags mismatch irq 1. 00000000 (cwq-0) vs. 00000000 (cwq-0)<br>May 24 13:1=
1:50 nvg5120 kernel: ------------[ cut here ]------------<br>May 24 13:11:5=
0 nvg5120 kernel: WARNING: CPU: 0 PID: 260 at /build/linux-c06pcb/linux-4.5=
.4/kernel/irq/manage.c:1449 __free_irq+0xac/0x2a0()<br>May 24 13:11:50 nvg5=
120 kernel: Trying to free already-free IRQ 1<br>May 24 13:11:50 nvg5120 ke=
rnel: Modules linked in: n2_crypto(E+) n2_rng(E+) sha512_sparc64(E+) rng_co=
re(E) des_generic(E) autofs4(E) ext4(E) ecb(E) <br>May 24 13:11:50 nvg5120 =
kernel: CPU: 0 PID: 260 Comm: systemd-udevd Tainted: G=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 E=C2=A0=C2=A0 4.5.0-2-sparc64=
-smp #1 Debian 4.5.4-1<br>May 24 13:11:50 nvg5120 kernel: Call Trace:<br>Ma=
y 24 13:11:50 nvg5120 kernel:=C2=A0 [00000000004669d0] warn_slowpath_common=
+0x70/0xc0<br>May 24 13:11:50 nvg5120 kernel:=C2=A0 [0000000000466a50] warn=
_slowpath_fmt+0x30/0x40<br>May 24 13:11:50 nvg5120 kernel:=C2=A0 [000000000=
04bdd0c] __free_irq+0xac/0x2a0<br>May 24 13:11:50 nvg5120 kernel:=C2=A0 [00=
000000004bdfa0] free_irq+0x40/0x80<br>May 24 13:11:50 nvg5120 kernel:=C2=A0=
 [0000000010aae24c] spu_list_destroy+0xec/0x100 [n2_crypto]<br>May 24 13:11=
:50 nvg5120 kernel:=C2=A0 [0000000010aafc98] spu_mdesc_scan+0x298/0x4a0 [n2=
_crypto]<br>May 24 13:11:50 nvg5120 kernel:=C2=A0 [0000000010ab0204] n2_cry=
pto_probe+0x1a4/0x680 [n2_crypto]<br>May 24 13:11:50 nvg5120 kernel:=C2=A0 =
[00000000007c95f4] platform_drv_probe+0x34/0xc0<br>May 24 13:11:50 nvg5120 =
kernel:=C2=A0 [00000000007c708c] driver_probe_device+0x24c/0x460<br>May 24 =
13:11:50 nvg5120 kernel:=C2=A0 [00000000007c7328] __driver_attach+0x88/0xa0=
<br>May 24 13:11:50 nvg5120 kernel:=C2=A0 [00000000007c497c] bus_for_each_d=
ev+0x5c/0xa0<br>May 24 13:11:50 nvg5120 kernel:=C2=A0 [00000000007c669c] dr=
iver_attach+0x1c/0x40<br>May 24 13:11:50 nvg5120 kernel:=C2=A0 [00000000007=
c60b0] bus_add_driver+0x1f0/0x2a0<br>May 24 13:11:50 nvg5120 kernel:=C2=A0 =
[00000000007c7db4] driver_register+0x74/0x120<br>May 24 13:11:50 nvg5120 ke=
rnel:=C2=A0 [00000000007c97c4] __platform_register_drivers+0x64/0x160<br>Ma=
y 24 13:11:50 nvg5120 kernel:=C2=A0 [0000000010ab6014] n2_init+0x14/0x24 [n=
2_crypto]<br>May 24 13:11:50 nvg5120 kernel: ---[ end trace 7aa1f0163177edf=
f ]---<br>May 24 13:11:50 nvg5120 kernel: camellia_sparc64: sparc64 camelli=
a opcodes not available.<br><br><br></div>Full boot logs, &quot;nosmp&quot;=
 and usual (smp) are in [1].<br><br>1. <a href=3D"https://bugzilla.kernel.o=
rg/show_bug.cgi?id=3D118831">https://bugzilla.kernel.org/show_bug.cgi?id=3D=
118831</a><br></div>

--001a114db5cec7abce0533955bcf--
