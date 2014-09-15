From: behanw@converseincode.com
Subject: [PATCH v3 00/12] LLVMLinux: Patches to enable the kernel to be compiled with clang/LLVM
Date: Mon, 15 Sep 2014 00:30:22 -0700
Message-ID: <1410766234-1634-1-git-send-email-behanw@converseincode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: akpm@linux-foundation.org, bruce.w.allan@intel.com,
	d.kasatkin@samsung.com, james.l.morris@oracle.com,
	john.griffin@intel.com, linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-ima-devel@lists.sourceforge.net,
	linux-ima-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-security-module@vger.kernel.org,
	neilb@suse.de, qat-linux@intel.com, serge@hallyn.com,
	thomas.lendacky@amd.com, zohar@linux.vnet.ibm.com,
	torvalds@linux-foundation.org,
	Behan Webster <behanw@converseincode.com>
To: agk@redhat.com, clm@fb.com, davem@davemloft.net,
	dm-devel@redhat.com, fabf@skynet.be, herbert@gondor.apana.org.au,
	jbacik@fb.com, snitzer@redhat.com, tadeusz.struk@intel.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

=46rom: Behan Webster <behanw@converseincode.com>

These patches replace the use of Variable Length Arrays In Structs (VLA=
IS) in
crypto related code with C99 compliant equivalent code. A SHASH_DESC_ON=
_STACK()
macro is added to hash.h which is then used to replace the use of VLAIS=
 in all
the other patches. The minimum size and alignment are maintained by the=
 new code.

The new code can be compiled with both gcc and clang.

The LLVMLinux project aims to fully build the Linux kernel using both g=
cc and
clang (the C front end for the LLVM compiler infrastructure project).=20

Behan Webster (6):
  crypto: LLVMLinux: Add macro to remove use of VLAIS in crypto code
  crypto: LLVMLinux: Remove VLAIS from crypto/mv_cesa.c
  crypto: LLVMLinux: Remove VLAIS from crypto/n2_core.c
  crypto: LLVMLinux: Remove VLAIS from crypto/omap_sham.c
  crypto: LLVMLinux: Remove VLAIS from crypto/.../qat_algs.c
  security, crypto: LLVMLinux: Remove VLAIS from ima_crypto.c

Jan-Simon M=C3=B6ller (5):
  crypto: LLVMLinux: Remove VLAIS from crypto/ccp/ccp-crypto-sha.c
  crypto, dm: LLVMLinux: Remove VLAIS usage from dm-crypt
  crypto: LLVMLinux: Remove VLAIS usage from crypto/hmac.c
  crypto: LLVMLinux: Remove VLAIS usage from libcrc32c.c
  crypto: LLVMLinux: Remove VLAIS usage from crypto/testmgr.c

Vin=C3=ADcius Tinti (1):
  btrfs: LLVMLinux: Remove VLAIS

 crypto/hmac.c                            | 25 +++++++---------
 crypto/testmgr.c                         | 14 ++++-----
 drivers/crypto/ccp/ccp-crypto-sha.c      | 13 ++++----
 drivers/crypto/mv_cesa.c                 | 41 +++++++++++-------------=
-
 drivers/crypto/n2_core.c                 | 11 +++----
 drivers/crypto/omap-sham.c               | 28 +++++++-----------
 drivers/crypto/qat/qat_common/qat_algs.c | 31 +++++++++----------
 drivers/md/dm-crypt.c                    | 34 +++++++++------------
 fs/btrfs/hash.c                          | 16 +++++-----
 include/crypto/hash.h                    |  5 ++++
 lib/libcrc32c.c                          | 16 +++++-----
 security/integrity/ima/ima_crypto.c      | 51 ++++++++++++++----------=
--------
 12 files changed, 126 insertions(+), 159 deletions(-)

--=20
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
