Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB7F3C2787
	for <linux-crypto@vger.kernel.org>; Sat, 13 Jun 2026 10:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781345209; cv=none; b=FO16ETbtFEjYwwgTwuM340VPm3sor9bWaC+NK1Wk4kO3LUL0bEHBFAKirqARShHPRxZRhxeIHxvfmsOeFlMv3kgiYcQ0nWUcdnGeBGuEMeJ5oiqeFw2pyjTvOfoDDQ2VUScmooW4L04gpKi+wp0RiEXSFf06cZdGkfUI1qDC76Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781345209; c=relaxed/simple;
	bh=TJ/upCYYuRm5Cx7wa1UDliHrZWPsIT7/2U6uEaEzupM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=avju6d2fDUEl1+k2UpcIK0YMmWQKzv/tWHEvi4yiGG7T6HXPVPmj20CVZSWpWXppgRyeF1xEgTftjUtrByPHeYrIeiLQMU/DzqD1VBG3e5H/zsja5tgq3DF8kbLbBMueIOuuVhktpI0bYv067jdL+ioa4KSywPhuZJ0HgnVU6Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m5hNWU2H; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m5hNWU2H"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-490b8adf813so2301085e9.1
        for <linux-crypto@vger.kernel.org>; Sat, 13 Jun 2026 03:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781345200; x=1781950000; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3oBqfpRAY+zECAwZLtJSuIalpAzdGoxXVuAiQRl3Bkg=;
        b=m5hNWU2HSfMTrhpcC3AfcmgzwcN6Pc99i5iK2P9IMI+FI/kuaQtk+BNKOZle1IpAu8
         NfA+aQT4lON2fNqs47MbVcWJLzIi27xXQp0nO5fbfhPyaZ5zraALBBh3NZ9fi8t/5YwV
         tho5AIQebN6kwp2YoJaezISXeAbTU6C1A0wiuzeHREo4f3ldhvXWehgvsgPmQgWBnrCn
         bCOUti2NEQRFPy7z27LJNmWdITnf3OvGh7une4jaAANwPy7KFcJXHHc5W4lap1er/H8l
         Jqilw8wPYhRy8Y3YaDhe1gMdPvASNGV4ThqLlm7xD+hTiENuwCQR227tRhngVXEWLkSJ
         /Ocw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781345200; x=1781950000;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3oBqfpRAY+zECAwZLtJSuIalpAzdGoxXVuAiQRl3Bkg=;
        b=bqPfnmte+33zRAT3Qh/vP7jhwfx98drrwEN9Q6pOTLn4ia8bkm2DOVsLt7r1ytylxr
         y56/4nFh9VljtcD5/2gkOOHZCWYdYDcDD74Vm7I+WtPJgXTDWdISq1NiAI9X5L34d99S
         AlsYpPc64D/7+5OZjcGvZtIE6vZxpYZPwx6ncZq3zCDEdhyUsN+KnBudPsAsGAIT9I29
         yrksZygAYFmpC1kKfOSczCikziRGrFolEhVS+0sF72Y8xP72HRp7P7X72znnpX6S+aXT
         rLll5NxNQf2ywKPEq7CnG5sIb593QEYXbAQ++1R3kackFt3FX5NHRPgSwZGGgZRYw4W/
         zGfw==
X-Gm-Message-State: AOJu0Yw0palLY9JkvurjdIoF62xDZLtndGh8uPDQcRjFdeF4LNqFQ/t2
	POlqTidAGsn+zFSGp9twPZNLc+IonJhTDo9yGlZP+3DOUb9u9bSylY0ULH33kQ==
X-Gm-Gg: Acq92OH4+UQGMnAaVzsw32rjGNvedrqMAr6aLG/FEYsULKTdaC3GKPmNCiQrI5rHQcb
	KiRcK5errh5FICBUo0zhnI/oAg0RodSPRt9P7PEmQqaEfwyDhofkvv2caSHq9/se7uURPjKo1LO
	suX/G7UV6wXMISYsm50d4DcazkgExv9QLy9PNMHaRH0Tp+H1vwNtROVuxB1vvMVm/k7seYERz2q
	LGtGhF4DMHdKK1XUlZdLJvAvykmeLVKfrmKdtPUM8bQWKRbM1w9wle0Pj35McRsNGgJRphe266M
	LFbkyws2cfiwA4J4hgXZR/pjEWODOqBl+t+YliR+VpzSm5f2r3pv/xPC9XU8U3IwNPKeSmxHi1V
	KduFMy3OT3I3aLndw599K1Iukx71s4Xd3HaKD1UWo35VEP74yBELNBKNdKYbNn0zlIyy7n/Yuw+
	KyCFQCWlYDJbiROAZ9itEjaYOTBiVmoAGTvq0UfAIlpsiua9AAIiySdhHGuPTCcXw=
X-Received: by 2002:a05:600c:4743:b0:492:1eaa:a8ba with SMTP id 5b1f17b1804b1-4921eaaa99bmr25666125e9.6.1781345200044;
        Sat, 13 Jun 2026 03:06:40 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4922032ae56sm61699805e9.7.2026.06.13.03.06.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 03:06:39 -0700 (PDT)
From: Lothar Rubusch <l.rubusch@gmail.com>
To: linux-crypto@vger.kernel.org,
	davem@davemloft.net,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com
Cc: thorsten.blum@linux.dev,
	herbert@gondor.apana.org.au,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	l.rubusch@gmail.com
Subject: Re: [PATCH] crypto: atmel-ecc - remove stale comments in atmel_ecc_remove
Date: Sat, 13 Jun 2026 10:06:38 +0000
Message-Id: <20260613100638.47312-1-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <aiqUBXIybgHXA6uj@linux.dev>
References: <aiqUBXIybgHXA6uj@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> From linux-crypto-vger  Thu Jun 11 10:55:01 2026
> From: Thorsten Blum <thorsten.blum () linux ! dev>
> Date: Thu, 11 Jun 2026 10:55:01 +0000
> To: linux-crypto-vger
> Subject: Re: [PATCH] crypto: atmel-ecc - remove stale comments in atmel_ecc_remove
> Message-Id: <aiqUBXIybgHXA6uj () linux ! dev>
> X-MARC-Message: https://marc.info/?l=linux-crypto-vger&m=178117527182807
> 
> On Thu, Jun 11, 2026 at 01:29:52PM +0800, Herbert Xu wrote:
> > On Tue, Jun 02, 2026 at 06:52:49PM +0200, Thorsten Blum wrote:
> > > atmel_ecc_remove() no longer returns -EBUSY since commit 7df7563b16aa
> > > ("crypto: atmel-ecc - Remove duplicated error reporting in .remove()")
> > > and is a void function since commit ed5c2f5fd10d ("i2c: Make remove
> > > callback return void").
> > > 
> > > Remove and update the outdated comments.
> > > 
> > > Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> > > ---
> > >  drivers/crypto/atmel-ecc.c | 6 ++----
> > >  1 file changed, 2 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
> > > index 9c380351d2f9..e6068dc0a0c1 100644
> > > --- a/drivers/crypto/atmel-ecc.c
> > > +++ b/drivers/crypto/atmel-ecc.c
> > > @@ -347,13 +347,11 @@ static void atmel_ecc_remove(struct i2c_client *client)
> > >  {
> > >  	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
> > >  
> > > -	/* Return EBUSY if i2c client already allocated. */
> > >  	if (atomic_read(&i2c_priv->tfm_count)) {
> > >  		/*
> > >  		 * After we return here, the memory backing the device is freed.
> > > -		 * That happens no matter what the return value of this function
> > > -		 * is because in the Linux device model there is no error
> > > -		 * handling for unbinding a driver.
> > > +		 * That happens because in the Linux device model there is no
> > > +		 * error handling for unbinding a driver.
> > >  		 * If there is still some action pending, it probably involves
> > >  		 * accessing the freed memory.
> > >  		 */
> > 
> > Please fix this properly rather than fiddling with the comments.
> > 
> > Drivers should always fail gracefully if the hardware disappears.
> 
> Yes, I'm working on a fix, but it's not ready yet.
> 

Hi guys, since this is going towards some work I already presented here and
still waiting on answer/request for comment from maintainer(s).
https://marc.info/?l=linux-kernel&m=178099821038957&w=2

The issue in the remove() arises when working with devres in combination with
asynch slow bus hardware, as we do here. AFAIK in the remove() are mainly two
options, either give a timeout to solve communication gracefully, then cut; or
wait indefinitely on the device to clear, in case forever.

When we cut off after timeout (first case) and still something arrives, it
would probably access freed memory resources. In the second case, simply
waiting on the device to resolve, might contain the risk of an infinite
waiting at driver removal. The other alternative would be to manage kmallocs
manually, i.e. to move away from devres (probably not what we want).
Currently, the driver just simply cuts off and has this problematic situation
very well spotted by the original author and commented.

Further, related to this situation in the remove() is using the global driver
data, which then might be overriden, and thus leak, when still around, and
this connects to dealing with synchronizing adding to the i2c_clientList and
algo registration, both happening in probe().

I tried to address all three issues. That's why the patch ended with such a
lengthy comment. The patch is reviewed by sashiko complaining only the above
dilemma.
https://sashiko.dev/#/patchset/20260609092927.47222-1-l.rubusch%40gmail.com

I hope I did not interfere too much with Thorstens fixes here. Since I assumed
you were active on rather different topics. Pls, let me know if so. I just
want to see this issue out of my way for the refac patch series.

Best,
L
