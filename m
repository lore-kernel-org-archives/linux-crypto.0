Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5E2330676
	for <linux-crypto@vger.kernel.org>; Sat, 15 Aug 2026 11:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786794355; cv=none; b=Q7Hm0j8JAmD95w2iuURVqhPOtBLGLSwJBaB0uzaZzcIxGaVRfIC5PID+uLp0Fva4mZwxLySu0ClIxuVN81UGKhs3Er6ShOzuVRNZbIBoWm66I6zkyVhaymcDbSFe0g4DN3kYHII9++v/fzicqQ7AQT7nECMPuPLR+/fjc/A6Izo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786794355; c=relaxed/simple;
	bh=8BVu8L2G1X/CbpvqHu+EXMf/KCNL//0MM9mN81VPOj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IILjOlllgzTbI7MndTVcdTXeWqTMMPi4FVjzwnZP8iiYh8KfDjyHPov2QkBGxCJ0yz4G/zEVLnCj24Hu4YYWFd+2H5WAO1Jpk5J8rwtiQsKI91N759UZHj6xryF4QVfqXBUN514ge2zuTV4lEpZwy11VlDyZWs3H90QVXc5tlaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=mdUhpf7y; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="mdUhpf7y"
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 6C0B83FCAC
	for <linux-crypto@vger.kernel.org>; Sat, 15 Aug 2026 11:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1786794350;
	bh=2xCf7NNzqXlGxdkctmUtmNccZAJf+QJ9HiKn7Wp1+x0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=mdUhpf7yF9cAAHHeDm2FN9mKgIq84AMcfLQoHSqNsOx+wg4FQxsbAtKlh+CrmTdEh
	 qSbRjOn/iqtn0RLn8oG6YpaoRCneLU41OyYyIgLIEU6BJM4OdmZvbsth9FJVtidovR
	 2GzVfYYmZNVFJjmLYstUGHZSfnQ/ePXSWp0iThhpwywHYa/M8NQLvSyeNLam8yUpng
	 L4IcIhnInDAVSSNX4UtaLCB/fdtHFZlBWYfMnaqWCamT6ynkyiwmR7HBMzVtdtzV9r
	 3ssBvF3ln+3WX1YzhJ2zSH8iJTf/Hxao2mcmYR12jx8/VS3QLjjdLbqZbk2Xle/iqa
	 KDL76LCZosMWWeVb/Vrwkz7nZ2zU9N5+9l49V1+2FNlObndDAMMklRqMZz5HlcPw/7
	 ttCgnXONUuPe7rrZ8WdnRt1cyq/4J4L0wmUvPJOlu2lmZ+D+fOvM4oIOyjmSv43lNw
	 6fdFrJFKrl6CuOS10gP4pPWgNw4pNXP8JXLI3EaE6we0oOaazUiJEaOfPgnfC6hQP7
	 W61adUopjmn5QasAp5YXevykxE7ScS6dozI1f7HhVaQin8fJ4D5kcYk/GHWAXVBMWR
	 l7tvgrnWuI14sZ4gtfmwkMi5MJp+PmaiAXR7GD+mtrQByf1ER7qZZL2RzDu/eRMl7U
	 34YQ4LtQdyuAV7lXAVMjHqaE=
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4815b878101so562648f8f.1
        for <linux-crypto@vger.kernel.org>; Sat, 15 Aug 2026 04:45:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786794350; x=1787399150;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2xCf7NNzqXlGxdkctmUtmNccZAJf+QJ9HiKn7Wp1+x0=;
        b=bKc8QuckPIMnYoaTdhDAYttjQijoivmtUzt8BQalIXABA4u/dy1IXMRWxZnZUTYCY3
         7ePF6563ejtbCXrEGh/rEfOeGe9k+r6CCCDTmHJI9O1Zb7CF3WPRUkh/Cr+WRRh+itz0
         YZpWmoGq5JkJ2mmSjVphmfnCTBilK530wT1bjGg0+oEOoVe1/ExP2UyWqZHZDzDdFoJk
         qCNAIhfTP+0OZKZSS4R2YrwlQBHslUnguYdLC+wAPjmy+XfposFg3B1okompnzd4JqS/
         9uLxiG43nlk91XBtN/Kz4ElLP/TSXNzEuR2NP4wNPEswuqf7EfHmaVywPZ8w59lt36A7
         Sz4Q==
X-Forwarded-Encrypted: i=1; AHgh+RrnrQyU/P+ZWpMmx62RCldCNSZxhQpVI2GZvf1QAO7HakveTe3S3zovSAKv1X8BhHQffM7l+4ESPB1Tn3Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+cQip44ATWZRNoZQXBHYOWc6Qx6gq8/ah4Pqcx/8vY1M5YRnd
	W/N0hF+nWbelNQH6uPxBWhrGlMf1xIA2fo4kj1lcTCu5VaglMzChkbFdOPb/8eDnK2lRWd52uSt
	lY+5eaH8r+3g2dPvDEawhkagJKT5qWOQSWJR48n0i9fUHhcFEBkweZiBM2jcwhEXghWAFbb39JZ
	+XAWKFZA==
X-Gm-Gg: AR+sD10cZza//vknNagEpNdhrB+N9tH4xJjYaobiW4fGfDaacwFQwW2lrhdMWT0G5O4
	aQkDq6cE1hiKReQ+mwjSLUkLM9gzvcRha0yAZx3+ONdOwEg6K1vxJIQrDm+/Dw2hZuKbmYtl9GX
	n7y9B71rFa3WDcYNWIjhqNXw/PgGo6Mb6STzJwsp6ZMRbCZpaYNx0/79LBKsYg31yzs1uzTrHn4
	hiiAtwiF8scWkxtfweCgBGuyGYRjXAGCRftFjFfaZcQY2aVBgjnO3BrVfVa2bt4vTGqljaOAtu0
	OWZdDdrALfWBaYbYX0EX2Qn0qa2CL61eErPWlV1RdttfeNfzEwK/DBrAQxF3Lq0ByuwC2IJbWaG
	/vIqlNonEhT6sSPFRvNApezVcQjlWvBiymq0tal/S06N8/KGoP+8He7w3E97eFTGY9EMJU9XjgQ
	2xduhrkZ30L+N6RCtWyjptRpn/1kYgnu0=
X-Received: by 2002:a05:6000:3105:b0:481:60fc:edd0 with SMTP id ffacd0b85a97d-48160fcf090mr16008103f8f.8.1786794349913;
        Sat, 15 Aug 2026 04:45:49 -0700 (PDT)
X-Received: by 2002:a05:6000:3105:b0:481:60fc:edd0 with SMTP id ffacd0b85a97d-48160fcf090mr16008041f8f.8.1786794349117;
        Sat, 15 Aug 2026 04:45:49 -0700 (PDT)
Received: from t-14.home (2a01cb000883230031a3fd8213e7cff4.ipv6.abo.wanadoo.fr. [2a01:cb00:883:2300:31a3:fd82:13e7:cff4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4815f2b13c3sm13090884f8f.19.2026.08.15.04.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2026 04:45:48 -0700 (PDT)
From: Fabrice Derepas <fabrice.derepas@canonical.com>
To: Ignat Korchagin <ignat@linux.win>
Cc: Fabrice Derepas <fabrice.derepas@canonical.com>,
	David Howells <dhowells@redhat.com>,
	Lukas Wunner <lukas@wunner.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: asymmetric_keys - bound PE section ranges in pefile_parse_binary
Date: Sat, 15 Aug 2026 13:45:30 +0200
Message-ID: <20260815114533.2171445-1-fabrice.derepas@canonical.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAOs+rJW1QymCXkr8-mU4kwMFvznnC98CXVvZMRjqpXwjJutdtA@mail.gmail.com>
References: <CAOs+rJW1QymCXkr8-mU4kwMFvznnC98CXVvZMRjqpXwjJutdtA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, Aug 14, 2026 at 11:29 PM Ignat Korchagin <ignat@linux.win> wrote:
> > Tested under KASAN (CONFIG_KASAN_GENERIC, x86-64) with a KUnit case that
> > calls verify_pefile_signature() on real images: a signed-then-tampered
>
> Same as your other patch - any reason not to include this KUnit case?

The reason I am not including my tests is that I use real signed EFI
binaries (a valid one and a tampered one), ~88 KB each via xxd -i, which is
a lot of binary to carry in-tree. For upstream I'll write a self-contained
case that constructs a minimal PE in the test itself and asserts that
pefile_parse_binary() rejects an out-of-range section, so there are no
embedded blobs. I'll send it as a second patch in a v3 series, so the fix
is not gated on the test.

> > +       for (loop = 0; loop < ctx->n_sections; loop++)
>
> Looking at the code again: seems ctx->n_sections is user-controlled.
> What happens if it is 0?

For this loop, nothing: n_sections is unsigned, so "loop < 0" is false on
the first test and the body never runs -- no chkaddr() call and no
ctx->secs[] dereference. So the patch itself adds no hazard for
n_sections == 0.

But you have pointed at a real pre-existing problem one step further on.
n_sections == 0 is not rejected anywhere -- pefile_parse_binary() only
bounds it from above, against header_size -- and pefile_digest_pe_contents()
then does:

	canon = kcalloc(ctx->n_sections, sizeof(unsigned), GFP_KERNEL);
	if (!canon)
		return -ENOMEM;
	...
	canon[0] = 0;

kcalloc(0, ...) returns ZERO_SIZE_PTR, which is non-NULL, so the !canon
check passes and the unconditional "canon[0] = 0" writes through
ZERO_SIZE_PTR. Because the digest runs only after verify_pkcs7_signature()
succeeds, this has the same reachability as the read this patch fixes: a
validly signed image with n_sections tampered to 0 (the PKCS#7 is
unaffected) reaches it via kexec_file_load().

I confirmed it under KASAN. With a trusted key embedded, a signed image
whose NumberOfSections I set to 0 (leaving the certificate table untouched,
so verify_pkcs7_signature() still returns 0) faults in the digest step,
while the untampered image verifies:

  control (trusted, 7 sections): verify_pefile_signature() = 0
  BUG: kernel NULL pointer dereference, address: 0000000000000010
  #PF: supervisor write access in kernel mode
  Oops: 0002 [#1] SMP KASAN NOPTI
  RIP: 0010:verify_pefile_signature+0x5c3   (pefile_digest_pe_contents inlined)

Address 0x10 is ZERO_SIZE_PTR and error_code 0x2 is a write -- the
canon[0] = 0 store -- so it is a write fault, reachable the same way as the
out-of-bounds read this patch already addresses.

Since we are now centralising section-table sanity in pefile_parse_binary(),
the natural fix is to reject n_sections == 0 there as well, e.g. by folding
it into the existing bound:

	if (ctx->n_sections == 0 ||
	    ctx->n_sections > (ctx->header_size - cursor) / sizeof(*sec))
		return -ELIBBAD;

A PE with zero sections is malformed (a signed kernel/EFI image always has
at least one), so rejecting it at parse is safe and closes the
ZERO_SIZE_PTR write too. I will include that in v3 and cover it in the KUnit
case.

Do you prefer it folded into this patch, or kept as a separate fix for the
canon[0] write? Either way I will respin as v3 with the KUnit case once you
let me know.

Thanks for the careful review, Ignat.

Fabrice
