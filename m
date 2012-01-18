From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: [PATCH 08/21] KEYS: Add signature verification facility [ver #3]
Date: Wed, 18 Jan 2012 15:26:05 +0200
Message-ID: <CALLzPKb4EycNZAd_80x-+p-iJ94CHerngOFZZmdrLpoJ+bYRMQ@mail.gmail.com>
References: <20111202184229.21874.25782.stgit@warthog.procyon.org.uk>
	<20111202184406.21874.65285.stgit@warthog.procyon.org.uk>
	<CALLzPKZFShWGxxic8zMfTxoj6Q+t7-sC90wp5J790VRmg-O09g@mail.gmail.com>
	<26123.1326889583@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com,
	arjan.van.de.ven@intel.com, alan.cox@intel.com
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga12.intel.com ([143.182.124.36]:55718 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754365Ab2ARN0H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Jan 2012 08:26:07 -0500
In-Reply-To: <26123.1326889583@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 18, 2012 at 2:26 PM, David Howells <dhowells@redhat.com> wr=
ote:
> Kasatkin, Dmitry <dmitry.kasatkin@intel.com> wrote:
>
>> It would also nice to have an API to supply pre-computed data hash. =
=C2=A0For
>> example IMA uses the same functionality to compute the hash of the f=
ile
>> content, and then, based on security.ima type decided either verify =
it using
>> just hash, or use digital signature. =C2=A0We could pass a hash as d=
ata. But may
>> be we do not want to have extra operation and compute hash over hash=
=2E
>
> If I understand you correctly, you'd like to have the option to do th=
e hashing
> externally to this API? =C2=A0Would you supply the completed hash or =
just a hash
> with the data in it, and require this API to complete it (ie. chuck m=
etadata
> into it)?
>

I meant just a hash of data..
Right, I remember, PGP finalizes hash with some additional metadata
pgp_pkey_digest_signature() seems does it...


> I don't think it should be hard. =C2=A0I could add an alternative to
> verify_sig_add_data() perhaps. =C2=A0Either that or one function that=
 does the lot
> and takes the precomputed hash as input. =C2=A0There would be no need=
 for the split
> into four functions (begin, add_data, end, cancel) in such a case. =C2=
=A0The reason
> for the split is so that the caller can invoke add_data several times=
 with
> non-contiguous bits of data.
>

Yes. it is clear...
Would it be possible to have pass data (uncompleted) hash?


> It might even make sense to expose the crypto hash object for direct =
access
> rather than use add_data - but that then makes it hard to use crypto =
hardware
> where you would just shovel the raw data into it and it does all the =
hashing
> and cryptography in a black box.
>
> David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypt=
o" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
