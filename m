Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91024233938
	for <linux-crypto@vger.kernel.org>; Sat, 25 Jul 2026 00:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784938430; cv=none; b=Vyolr69Smt5sQjlT7Y5HE2WpgQfZ6LxMNANzLRv3y+Fg9rpgRdpVFibxgnB7AFISPIX/OvehwiII6JtCPmOCJ4zzmgofsePeAkzjh4guZwd95ZapAovr3526ioO0wU37JfR5QUPyiRRHlW5KjRfCG7O8QdrFw90TLo73ksThtTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784938430; c=relaxed/simple;
	bh=6G+bK5t21cOF/PCSCNxZhSwNWWyGfAQDxqVwxXb4DPI=;
	h=Message-ID:In-Reply-To:References:From:To:Subject:Date:
	 MIME-Version:Content-Type; b=jr6SpR9mD+kMvZzeaYujj/s1zXj1nSUWEWcHUoTbvS4P7tldwp1wZ6kGk7YkiF8Iko72m1hzVfoBGMQAnbs5tuIy22L6YEIW07phxfb0r+zEHC9mDPyeB+5FpEH64KhFlyW9M7z9h2A7JYsnCpL/lFZrLVWwIolxN99hl+THEb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gosalescloserapp.com; spf=pass smtp.mailfrom=gosalescloserapp.com; dkim=pass (2048-bit key) header.d=gosalescloserapp.com header.i=@gosalescloserapp.com header.b=jxSuTYwB; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gosalescloserapp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gosalescloserapp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gosalescloserapp.com header.i=@gosalescloserapp.com header.b="jxSuTYwB"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-92ed3993c1eso59463385a.1
        for <linux-crypto@vger.kernel.org>; Fri, 24 Jul 2026 17:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gosalescloserapp.com; s=google; t=1784938427; x=1785543227; darn=vger.kernel.org;
        h=content-type:mime-version:date:content-transfer-encoding:subject:to
         :from:references:in-reply-to:message-id:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6G+bK5t21cOF/PCSCNxZhSwNWWyGfAQDxqVwxXb4DPI=;
        b=jxSuTYwBj198hAIfqT6GFagTB7qIaJ5A9MPYxxJRZUiOz1pmLp5KGglGfqVPqy/dVf
         fmMnp5IQ+aaeuk0LXC0gRVbUKBszw/sEPVaE64M6rado5Iyh69OcUeXb3YfVJRCCTudT
         5KBEIssvSyoUTxuSicy45qfACar0LdlKChEKG6FQpRTn7GG4D384KmKWot9RScL7GRQV
         b/x10ai+I3VxPmpyC/5ozp0dRmuNde9MAf3UPQD9hGa9pP9jdAGP54GpNfkVK2zZ5SOQ
         KOTwOcM821iqUhlgAV6c5UtunoKX5wVmVV8uA+wcySrrHkgc7I8vq+W0VY2zWGzm6/Nm
         s5Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784938427; x=1785543227;
        h=content-type:mime-version:date:content-transfer-encoding:subject:to
         :from:references:in-reply-to:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6G+bK5t21cOF/PCSCNxZhSwNWWyGfAQDxqVwxXb4DPI=;
        b=nWM3BnRKRayiTj+kDy6+Wif/N0iE3Iz7wwR8I7A8gNS9WuLlTq/NpODso5eSkHJ4B/
         uGnADx92bvZrfMbftHpGn09TF6SHxX4YDKPrHq8nCR2Zh3ikl10PoL6/lPFY8rF7l11f
         BWMCTY8Uju0H0nvodljMaQrT9xAxwprpBsRKxkerGMVtpabcC3K+40mVbbemCDuj4i1B
         OVSlbyHIj3/Ytdydz+996goiwlR71okNgPDsVNZHVqgB8dzqYLmPqcOjXE58zLe25+8k
         W2wrn9ZtLdnll4IBpM58UW2Bqm6u103GgmMcDOJrXbvvM6AhEd+IUzGZKUjwJMdulH8C
         ugcg==
X-Gm-Message-State: AOJu0YxIOUIlDY+3RuPItxV4AQh2SkRx2lzg6tYg+bg19yiZKelHqTm9
	7TZ9NVoUUrQg+DXKBGTYG8VRwyV6cDOlkd+lc5PzU5L/eBBg1b59CUQ3e4hQGaPnXLYvGzX7roH
	x38afjw==
X-Gm-Gg: AR+sD12c88mCYYYLyJmhLuQJKnOrOQao/A52lWLZ1J4GXBlXUB0YL9tiMaRMaYMGjwU
	RWWIlM90KhshA/eHSemMySk9Az/D0c8eKb/TApHMYgkyjqOInHQJU5kW6Pt3cza5wZVhXXDHOW3
	QoNs3NylNqdncYQ2cd/qrSsi6quY54sXA4SxrJf1SfTcuadJGxboLKdQd1WdSskUFY55Pv6TCy2
	S07cDXHk9IFrFNU6FQ50LgMkZdmdUZrVbe5X/7wMsl0j4wlmdJd/VfDiAk0H3aaG0HZYRyMNgY7
	U6iPsDFlh3cIfEmsPs+fYS8fHc3LzF95FbFHg+taGDbZJpanWrQoMvB3gOF+DMYGcGzJgzkukVI
	hITf/HQzVf0L1nU5pusi2jZ5XIBbYm3+RWg0NtLCwgDiWSXUOgRPvplarVNPxC0KzY/0+nJn/di
	bt/ZajeFWrZw5U+EbDzZXTA9FOyyKUA4euVIZuFSSrLhmLmm2XKYk6H4qyqNgHbU0dAU/Sbkyug
	Wilsu9IjmQf1Ql09dcc2ChzKmdQDAefz9Li2Q==
X-Received: by 2002:a05:620a:25ce:b0:92e:e559:fe6b with SMTP id af79cd13be357-932df627d47mr33427685a.7.1784938427122;
        Fri, 24 Jul 2026 17:13:47 -0700 (PDT)
Received: from 019f969e-effd-7c69-8b5d-8c53c3926c48.local (ec2-44-192-23-44.compute-1.amazonaws.com. [44.192.23.44])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-932de655fcasm34011685a.36.2026.07.24.17.13.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 17:13:46 -0700 (PDT)
Message-ID: <019f969e-effd-7c69-8b5d-8c53c3926c48@gosalescloserapp.com>
In-Reply-To: <019f8c49-5228-7909-b3ee-a449a6f1c14b@gosalescloserapp.com>
References: <019f8c49-5228-7909-b3ee-a449a6f1c14b@gosalescloserapp.com>
X-Mail-Abuse-Inquiries:
 https://app.instantly.ai/privacy/report-abuse/019f969e-effd-7c69-8b5d-8c53c3926c48
From: Emily Cooper <emilycooper@gosalescloserapp.com>
To: linux-crypto@vger.kernel.org
Subject: Re: Yale Blockchain Initiative sales
Content-Transfer-Encoding: quoted-printable
Date: Sat, 25 Jul 2026 00:13:46 +0000
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8

Hi,

Just checking if you had a chance to think about the AI platform I =
mentioned.

Would you be open to a quick chat to see if it fits your setup?
=C2=A0

On Thu, July 23, 2026 12:04 AM, Emily Cooper =
<emilycooper@gosalescloserapp.com>
[emilycooper@gosalescloserapp.com]> =
wrote:

> Hi,
>=20
> I noticed how the volatility of Bitcoin=E2=80=99s =
price can make it tough to stay on top of client communications and leads =
in the crypto space.
>=20
> An AI-driven platform can help manage calls and=
 meetings smoothly without stretching your current resources.
>=20
> One of our users in fintech found it easier to keep prospects engaged and=
 schedule appointments even during market swings.
>=20
> Would you be open to exploring how this kind of support could fit into =
your workflow?
>=20
>=20
> Best
> -Emily
>=20
> P.S: let me know if =
irrelevant.
>
