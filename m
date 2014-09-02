From: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH RFC 0/6] LLVMLinux: Patches to enable the kernel to be compiled with clang/LLVM
Date: Tue, 2 Sep 2014 16:01:42 -0700
Message-ID: <05DCB0B8-AA7C-495F-B8E6-0803052DD273@holtmann.org>
References: <1409697153-7006-1-git-send-email-behanw@converseincode.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Alasdair Kergon <agk@redhat.com>, clm@fb.com,
	"David S. Miller" <davem@davemloft.net>, dm-devel@redhat.com,
	Fabian Frederick <fabf@skynet.be>,
	Herbert Xu <herbert@gondor.apana.org.au>, jbacik@fb.com,
	snitzer@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
	james.l.morris@oracle.com, john.johansen@canonical.com,
	linux-btrfs@vger.kernel.org, linux-crypto@vger.kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-raid@vger.kernel.org, linux-security-module@vger.kernel.org,
	neilb@suse.de, serge@hallyn.com,
	Linus Torvalds <torvalds@linux-foundation.org>
To: behanw@converseincode.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1409697153-7006-1-git-send-email-behanw@converseincode.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Behan,

> These patches remove the use of Variable Length Arrays In Structs (VL=
AIS) in
> crypto related code. Presented here for comments as a whole (since th=
ey all do
> the same thing in the same way). Once everyone is happy I will submit=
 them
> individually to their appropriate maintainers.
>=20
> The LLVMLinux project aims to fully build the Linux kernel using both=
 gcc and
> clang (the C front end for the LLVM compiler infrastructure project).=
=20
>=20
>=20
> Jan-Simon M=F6ller (4):
>  crypto, dm: LLVMLinux: Remove VLAIS usage from dm-crypt
>  crypto: LLVMLinux: Remove VLAIS usage from crypto/hmac.c
>  crypto: LLVMLinux: Remove VLAIS usage from libcrc32c.c
>  crypto: LLVMLinux: Remove VLAIS usage from crypto/testmgr.c
>=20
> Vin=EDcius Tinti (2):
>  apparmor: LLVMLinux: Remove VLAIS
>  btrfs: LLVMLinux: Remove VLAIS
>=20
> crypto/hmac.c              | 27 +++++++++++++--------------
> crypto/testmgr.c           | 16 ++++++++--------
> drivers/md/dm-crypt.c      | 38 ++++++++++++++++++-------------------=
-
> fs/btrfs/hash.c            | 18 +++++++++---------
> lib/libcrc32c.c            | 18 +++++++++---------
> security/apparmor/crypto.c | 19 +++++++++----------
> 6 files changed, 66 insertions(+), 70 deletions(-)

are you sure these are all of them? I know for a fact that we are using=
 the same construct in net/bluetooth/amp.c as well.

Regards

Marcel
