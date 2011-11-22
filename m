From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: crypto_ahash_setkey
Date: Wed, 23 Nov 2011 00:00:29 +0200
Message-ID: <CALLzPKYbbYV9keL7DAFfHVzn3SqQv3-1X+cJCp2hn2-ey9UpOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:61598 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758581Ab1KVWAb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Nov 2011 17:00:31 -0500
Received: by qabg14 with SMTP id g14so2791038qab.4
        for <linux-crypto@vger.kernel.org>; Tue, 22 Nov 2011 14:00:30 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I have noticed very odd behavior with hmac calculation on my dual
core, 4 HTs PC.
I am using async hash API to to calculate hmac over the page.
I am using "hmac(sha1)" and the same key to calculate different pages.

I have a work queue, which calculates the hmac like...

int()
{
    tfm = crypto_alloc_ahash(...);
}

work_task()
{
     crypto_ahash_setkey(tfm, key, keylen);
     crypto_ahash_digest(req);
}

HMAC result "sometimes" is incorrect.

But when I move crypto_ahash_setkey() do the initialization code then
HMAC result is always correct...
(key is the same, so I can initialize it only once)

int()
{
     tfm = crypto_alloc_ahash(...);
     crypto_ahash_setkey(tfm, key, keylen);
}

work_task()
{
     crypto_ahash_digest(req);
}

It seems that crypto_ahash_setkey() somehow sometimes does wrong things...

I hope my explanation is clear.

Any ideas why it might happen?

Thanks,

- Dmitry
