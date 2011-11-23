From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: crypto_ahash_setkey
Date: Wed, 23 Nov 2011 11:09:30 +0200
Message-ID: <CALLzPKZtmW286CbHQHfkMeX=kOCfPLxkOHt+HOEXjCOfqs0RKA@mail.gmail.com>
References: <CALLzPKYbbYV9keL7DAFfHVzn3SqQv3-1X+cJCp2hn2-ey9UpOw@mail.gmail.com>
	<20111123060853.GH20943@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:29926 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753296Ab1KWJJc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Nov 2011 04:09:32 -0500
Received: by qyl16 with SMTP id 16so2338020qyl.25
        for <linux-crypto@vger.kernel.org>; Wed, 23 Nov 2011 01:09:30 -0800 (PST)
In-Reply-To: <20111123060853.GH20943@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 23, 2011 at 8:08 AM, Steffen Klassert
<steffen.klassert@secunet.com> wrote:
> Hi.
>
> On Wed, Nov 23, 2011 at 12:00:29AM +0200, Kasatkin, Dmitry wrote:
>> Hi,
>>
>> I have noticed very odd behavior with hmac calculation on my dual
>> core, 4 HTs PC.
>> I am using async hash API to to calculate hmac over the page.
>> I am using "hmac(sha1)" and the same key to calculate different page=
s.
>>
>> I have a work queue, which calculates the hmac like...
>>
>> int()
>> {
>> =C2=A0 =C2=A0 tfm =3D crypto_alloc_ahash(...);
>> }
>>
>> work_task()
>> {
>> =C2=A0 =C2=A0 =C2=A0crypto_ahash_setkey(tfm, key, keylen);
>> =C2=A0 =C2=A0 =C2=A0crypto_ahash_digest(req);
>> }
>>
>> HMAC result "sometimes" is incorrect.
>
> Looks like a race. HMAC precalculates the hash of the ipaded/opaded k=
ey
> and saves this hash on the transform. So the setkey method should be =
used
> just once in the initialization path.
>
>>
>> But when I move crypto_ahash_setkey() do the initialization code the=
n
>> HMAC result is always correct...
>> (key is the same, so I can initialize it only once)
>>
>> int()
>> {
>> =C2=A0 =C2=A0 =C2=A0tfm =3D crypto_alloc_ahash(...);
>> =C2=A0 =C2=A0 =C2=A0crypto_ahash_setkey(tfm, key, keylen);
>> }
>
> That's how it should be. And in this case it works, as you
> already noticed :)
>
>

Thanks...
See my another reply...
