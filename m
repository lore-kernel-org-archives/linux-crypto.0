From: Behan Webster <behanw@converseincode.com>
Subject: Re: [PATCH RFC 0/6] LLVMLinux: Patches to enable the kernel to be
 compiled with clang/LLVM
Date: Tue, 02 Sep 2014 16:07:24 -0700
Message-ID: <54064DAC.9050602@converseincode.com>
References: <1409697153-7006-1-git-send-email-behanw@converseincode.com> <05DCB0B8-AA7C-495F-B8E6-0803052DD273@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
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
To: Marcel Holtmann <marcel@holtmann.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <05DCB0B8-AA7C-495F-B8E6-0803052DD273@holtmann.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 09/02/14 16:01, Marcel Holtmann wrote:
> Hi Behan,
>
>> These patches remove the use of Variable Length Arrays In Structs (V=
LAIS) in
>> crypto related code. Presented here for comments as a whole (since t=
hey all do
>> the same thing in the same way). Once everyone is happy I will submi=
t them
>> individually to their appropriate maintainers.
>>
>> The LLVMLinux project aims to fully build the Linux kernel using bot=
h gcc and
>> clang (the C front end for the LLVM compiler infrastructure project)=
=2E
>>
>>
>> Jan-Simon M=F6ller (4):
>>   crypto, dm: LLVMLinux: Remove VLAIS usage from dm-crypt
>>   crypto: LLVMLinux: Remove VLAIS usage from crypto/hmac.c
>>   crypto: LLVMLinux: Remove VLAIS usage from libcrc32c.c
>>   crypto: LLVMLinux: Remove VLAIS usage from crypto/testmgr.c
>>
>> Vin=EDcius Tinti (2):
>>   apparmor: LLVMLinux: Remove VLAIS
>>   btrfs: LLVMLinux: Remove VLAIS
>>
>> crypto/hmac.c              | 27 +++++++++++++--------------
>> crypto/testmgr.c           | 16 ++++++++--------
>> drivers/md/dm-crypt.c      | 38 ++++++++++++++++++------------------=
--
>> fs/btrfs/hash.c            | 18 +++++++++---------
>> lib/libcrc32c.c            | 18 +++++++++---------
>> security/apparmor/crypto.c | 19 +++++++++----------
>> 6 files changed, 66 insertions(+), 70 deletions(-)
> are you sure these are all of them? I know for a fact that we are usi=
ng the same construct in net/bluetooth/amp.c as well.
There have been other places where this was an issue before too (ext4,=20
mac80211, USB gadget, ...). Some have already been fixed.

Hmm. Yeah, I thought we had a patch for bluetooth too. I can't find it=20
now though.

Suffice it to say that similar patches are required for the other=20
instances of this kind of code elsewhere as well.

Thanks Marcel,

Behan

--=20
Behan Webster
behanw@converseincode.com
