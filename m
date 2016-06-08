From: Anatoly Pugachev <matorola@gmail.com>
Subject: [sparc] niagara2 cpu, opcodes not available message?
Date: Wed, 8 Jun 2016 20:30:40 +0300
Message-ID: <CADxRZqwr9=9ZsrFR_8iC+f1Z=hSPi7Saj3uxB2=YmH42sVf6pQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: debian-sparc <debian-sparc@lists.debian.org>,
	linux-crypto@vger.kernel.org
To: sparclinux@vger.kernel.org
Return-path: <sparclinux-owner@vger.kernel.org>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello!

Can someone please tell, why do we get a bunch of the following
messages on niagara2 cpu hardware (SPARC Enterprise T5120, T5220,
T5140, and T5240 servers)

Asking, because I see the following lines on kernel boot (removing
first field boot time stamp in cut):

mator@nvg5120:~/linux-sparc-boot-logs/t5120$ grep opcode
dmesg-4.7.0-rc2+.log  | cut -f2- -d' ' | sort | uniq -c
      4 aes_sparc64: sparc64 aes opcodes not available.
      7 camellia_sparc64: sparc64 camellia opcodes not available.
     37 crc32c_sparc64: sparc64 crc32c opcode not available.
      5 des_sparc64: sparc64 des opcodes not available.
      4 md5_sparc64: sparc64 md5 opcode not available.
      1 sha1_sparc64: sparc64 sha1 opcode not available.
      2 sha256_sparc64: sparc64 sha256 opcode not available.
      3 sha512_sparc64: sparc64 sha512 opcode not available.

But linux kernel sources ( linux-2.6/arch/sparc/kernel/setup_64.c )
define crypto_hwcaps only for CPUs with the following capabilities:

static const char *crypto_hwcaps[] = {
        "aes", "des", "kasumi", "camellia", "md5", "sha1", "sha256",
        "sha512", "mpmul", "montmul", "montsqr", "crc32c",
};

and we don't have them in niagara2 cpu CAPS:

mator@nvg5120:~/linux-sparc-boot-logs/t5120$ grep CAPS dmesg-4.7.0-rc2+.log
[    0.000000] CPU CAPS: [flush,stbar,swap,muldiv,v9,blkinit,n2,mul32]
[    0.000000] CPU CAPS: [div32,v8plus,popc,vis,vis2,ASIBlkInit]

mator@nvg5120:~/linux-sparc-boot-logs/t5120$ egrep '^cpu|pmu' /proc/cpuinfo
cpu             : UltraSparc T2 (Niagara2)
pmu             : niagara2
cpucaps         :
flush,stbar,swap,muldiv,v9,blkinit,n2,mul32,div32,v8plus,popc,vis,vis2,ASIBlkInit


compare, for example, with sparc CPU which support crypto (T5 cpu,
landau is machine name):

mator@landau:~$ grep CAPS dmesg-4.6.1.txt
[    0.000000] CPU CAPS: [flush,stbar,swap,muldiv,v9,blkinit,n2,mul32]
[    0.000000] CPU CAPS: [div32,v8plus,popc,vis,vis2,ASIBlkInit,fmaf,vis3]
[    0.000000] CPU CAPS: [hpc,ima,pause,cbcond,aes,des,kasumi,camellia]
[    0.000000] CPU CAPS: [md5,sha1,sha256,sha512,mpmul,montmul,montsqr,crc32c]

mator@landau:~$ egrep '^cpu|pmu' /proc/cpuinfo
cpu             : UltraSparc T5 (Niagara5)
pmu             : niagara5
cpucaps         :
flush,stbar,swap,muldiv,v9,blkinit,n2,mul32,div32,v8plus,popc,vis,vis2,ASIBlkInit,fmaf,vis3,hpc,ima,pause,cbcond,aes,des,kasumi,camellia,md5,sha1,sha256,sha512,mpmul,montmul,montsqr,crc32c

mator@landau:~$ grep opcode dmesg-4.6.1.txt
[8537574.887049] aes_sparc64: Using sparc64 aes opcodes optimized AES
implementation
[8537574.887611] crc32c_sparc64: Using sparc64 crc32c opcode optimized
CRC32C implementation
[8537576.577455] sha1_sparc64: Using sparc64 sha1 opcode optimized
SHA-1 implementation
[8537576.578928] sha256_sparc64: Using sparc64 sha256 opcode optimized
SHA-256/SHA-224 implementation
[8537576.580908] sha512_sparc64: Using sparc64 sha512 opcode optimized
SHA-512/SHA-384 implementation
[8537576.582964] md5_sparc64: Using sparc64 md5 opcode optimized MD5
implementation
[8537576.596984] des_sparc64: Using sparc64 des opcodes optimized DES
implementation
[8537576.600503] camellia_sparc64: Using sparc64 camellia opcodes
optimized CAMELLIA implementation


I don't understand why niagara2 cpu getting HWCAP_SPARC_CRYPTO flag if
it does not support it.
Can we probably remove this functionality/messages from niagara2 cpus,
if it does not support it anyway?

mator@nvg5120:~$ lsmod | grep -c sparc64
0

mator@landau:~$ lsmod | grep -c sparc64
9




Thanks.
