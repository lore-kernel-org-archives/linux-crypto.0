From: Behan Webster <behanw@converseincode.com>
Subject: [PATCH 0/2] Removing the use of VLAIS from the Linux Kernel
Date: Tue, 30 Oct 2012 14:37:27 -0400
Message-ID: <1351622249-18084-1-git-send-email-behanw@converseincode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Behan Webster <behanw@converseincode.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The use of variable length arrays in structs (VLAIS) in the Linux Kerne=
l code
precludes the use of compilers which don't implement VLAIS (for instanc=
e the
Clang compiler). The LLVMLinux Project is working towards the ability o=
f
providing the Linux kernel developer the choice of using the Clang comp=
iler
toolchain. This is a part of a series of patches which remove the use o=
f VLAIS
from crypto code, dm-crypt, jbd2, libcrc32c, netfilter, and usb gadget.=
 Other
patches to allow Clang to be used will follow.

Jan-Simon M=C3=B6ller (2):
  Remove VLAIS usage from crypto/hmac.c
  Remove VLAIS usage from crypto/testmgr.c

 crypto/hmac.c    |   27 +++++++++++++--------------
 crypto/testmgr.c |   23 +++++++++++++----------
 2 files changed, 26 insertions(+), 24 deletions(-)

--=20
1.7.9.5
