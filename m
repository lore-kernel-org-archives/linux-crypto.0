From: leroy christophe <christophe.leroy-GgN8y9CXRhA@public.gmane.org>
Subject: Re: [PATCH 0/17] crypto: talitos - Add support for SEC1
Date: Fri, 06 Mar 2015 09:39:44 +0100
Message-ID: <54F967D0.5030209@c-s.fr>
References: <20150305164605.E65D81A241C@localhost.localdomain> <20150305182101.6db66e228f519476f0751c13@freescale.com> <20150306002831.GA30947@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>,
	Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
	Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>,
	Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	Kim Phillips <kim.phillips-KZfg59tc24xl57MIdRCFDg@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150306002831.GA30947-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Le 06/03/2015 01:28, Herbert Xu a =E9crit :
> On Thu, Mar 05, 2015 at 06:21:01PM -0600, Kim Phillips wrote:
>> On Thu, 5 Mar 2015 17:46:05 +0100
>> Christophe Leroy <christophe.leroy-GgN8y9CXRhA@public.gmane.org> wrote:
>>
>>> [15/17] crypto: talitos - Implementation of SEC1
>> ...
>>
>>> [16/17] crypto: talitos - SEC1 bugs on 0 data hash
>>> [17/17] crypto: talitos - Update DT bindings with SEC1
>> This patchseries doesn't apply, at least on top of Herbert's
>> cryptodev-2.6 tree, as of today:
>>
>> Applying: crypto: talitos - Implementation of SEC1
>> error: patch failed: drivers/crypto/talitos.c:655
>> error: drivers/crypto/talitos.c: patch does not apply
> Also the patches are coming in a random order.  Please send them
> one at a time to ensure proper ordering.
>
> Thanks,
Kim, I have now tried on top of cryptodev-2.6 tree, and for me it works=
=20
(see below).
Do I clone cryptodev-2.6 from the wrong place ?
On that clone, the latest commit on talitos.c is commit=20
5be4d4c94b1f98b839344fda7a8752a4a09d0ef5 "crypto: replace=20
scatterwalk_sg_next with sg_next"

[root@localhost ~]# git clone=20
https://www.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.g=
it
Cloning into 'cryptodev-2.6'...
remote: Counting objects: 4043448, done.
remote: Compressing objects: 100% (682829/682829), done.
Receiving objects: 100% (4043448/4043448), 893.52 MiB | 258.00 KiB/s, d=
one.
remote: Total 4043448 (delta 3330215), reused 4043104 (delta 3329977)
Resolving deltas: 100% (3330215/3330215), done.
Checking connectivity... done.
Checking out files: 100% (48971/48971), done.
[root@localhost ~]# cd cryptodev-2.6/
[root@localhost cryptodev-2.6]# git branch test
[root@localhost cryptodev-2.6]# git checkout test
Switched to branch 'test'
[root@localhost cryptodev-2.6]# git am=20
/root/gen/trunk/submitted_patches/talitos/0*
Applying: crypto: talitos - base address for Execution Units and macro=20
for ISR masks
Applying: crypto: talitos - Externalise specific SEC2 reset actions
Applying: crypto: talitos - Use zero entry to init descriptors ptrs to =
zero
Applying: crypto: talitos - Refactor the sg in/out chain allocation
Applying: crypto: talitos - isolate scatter/gather handling for ahash
Applying: crypto: talitos - Add talitos2.c to isolate SEC2 specific=20
functions
Applying: crypto: talitos - Split talitos.h into 2 parts
Applying: crypto: talitos - Deport SEC2 error handling
Applying: crypto: talitos - Move reset/init helpers into talitos2.h
Applying: crypto: talitos - Move interrupt related macros in talitos2.h
Applying: crypto: talitos - Move hash chain handling into talitos2.h
Applying: crypto: talitos - Define compatible in talitos2.h instead of=20
talitos.c
Applying: crypto: talitos - move sg_count() helper into talitos.h
Applying: crypto: talitos - Add a helper function to clear j_extent fie=
ld
Applying: crypto: talitos - Implementation of SEC1
Applying: crypto: talitos - SEC1 bugs on 0 data hash
Applying: crypto: talitos - Update DT bindings with SEC1
[root@localhost cryptodev-2.6]#

--
To unsubscribe from this list: send the line "unsubscribe devicetree" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
