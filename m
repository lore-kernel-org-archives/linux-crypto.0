Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.222.175
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793644620;
	b=M2kX/Kh6oeIlCaadOsyqCeDg4SoGbIqgtTyDltqzSEuTP6CkO/dek7fIgEKVhvsAxImA
	 b9i5EN3yfy2+F6pl5S1dQ/RTX+AE0SWS4iAoEoCfMvCzTF3eRtlCy2TXZnafBBM2KOHC8
	 UFomnqamA+LzfVpdpIazLljwj2e91VLMfXBCtijzCXL2YJBSQIT6ejUMmb6lyMUGCxrb1
	 fLtH3OcaiEM5Ch8Pra3VG6IH3n85LOaEmNV1TlCO9ZHz2oNEoHHg5hkr9+Srx+7PDujEA
	 A/EKcV7cWGH8IGVYQEpQYeAjrHnmi1dUjfQAQmROIKZxHNKS6BjSXviTbU5Tr7juAWQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793644620;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:In-Reply-To:References:MIME-Version:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=1u8rN1C+JF6DQIQz6Nin0TnpQFmY/6RtXJ4cFBXNPgw=;
	b=Bbpwj750iTfhZK7WK0oVRKBAxuUaYw7BbwKW10EWTdb9aKgPIew1F9v8P8cpOuC7gyP9
	 XZFAYzDQjdnIXvQ0BoSxu192u7MC12DcchCc8Jcq23FkP1WzN1zLb0PyQwOVA8euAs5c6
	 m77UtBv5XMu+ctr9akgee5BiQjlHNeYW/nJq8PDiT7PIDQOzBZeCyWjGqDrVkL30ygVxc
	 FGHglBut2ZI2tmz50XlA0ZAN/BNoXA5G5ClOukQ43IUo+VuF9V9P17u6TkIDG3CM993BC
	 LklepD+/opucLst0eiZLk7YMuG7MV49+0nXEgMiukaZ3jB44rRSaWcAWMRT6pmrr0Dg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=d+0Wf7Yz;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.222.175
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FDC1606A324
	for <linux-crypto@vger.kernel.org>; Mon,  2 Nov 2026 18:37:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2FDC1606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=d+0Wf7Yz
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-93f1cf92c9eso318513985a.0
        for <linux-crypto@vger.kernel.org>; Mon, 02 Nov 2026 10:37:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793644619; cv=none;
        d=google.com; s=arc-20260327;
        b=j45U5FP5B7psx8Ori9l6Pxhl4BsT1ll/FSEd11w21klYH1nuac9C3nOV7x+JT5W+Wh
         ff6obZnSzTT2wCKNCFHmZwWWC/626aP+cxLm3r6JRI/0uVt6u8Lmu0r7KdLwNOCCQvl+
         ElOIRu4Io1CcOeXFfAzwJDkB1+R1CMUEKBUpEUJOwRTbL7hBXGEKcjEP+kQIbjXVWqqS
         14LheuuHkvVxPoc7mQyJjkpZ2Ywt+/JRanN92Npts2p6Z1s06m6iYQzdzHVavI4FkeWb
         oa4fP9aDUdVQUNt5khVkbyEAEvFdLemi5lQahzDoY6ToD8vkGuno0gNFBl+b2WCiTNOo
         yN/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=1u8rN1C+JF6DQIQz6Nin0TnpQFmY/6RtXJ4cFBXNPgw=;
        fh=+bk+4XXuxoFaHZGSTnVMruu9PAXoTPTYCNYEZflKzTI=;
        b=Cw7Etz/+/PpPW2/NPSM63mPuutEOEF0jF9JdIyNdypTea49ywEUAXlRmESwBL2+goO
         kxw8Q4TeAj6YQyeAmk+8zuVpZubrRTNOmsLO+fh7j9cwr1Us63t9d980t00UK5n1a0BN
         5DjAATfKWAFD7OxZg1Nr+a81BAv0wEQadF4MsLrqkNEr9b8n9NTdY85agV+xA+xFibMO
         70hWA3/VYW1pEItCuqLYVoi22zx8Fxr1RuvQ9Ept9R4If1XztTC88Sq22VHTkyBSPqwW
         /wox/tlkSee8SeW16aZIq2tq0c09JWOSBZqPhjwLlyw9uu2j2HxWhxtae3764kiWlXlf
         Wgng==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793644619; x=1794249419; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1u8rN1C+JF6DQIQz6Nin0TnpQFmY/6RtXJ4cFBXNPgw=;
        b=d+0Wf7YzvBo0BNjiQGKoBLF600dJbYmztVCqwLoaY3rGW4pb3Ocs8o0r/N63nNpppN
         xqop/kdveWCP2WnqlyWZmZwJdVbfbYcPshLTGEai/zXM7lRtGL0tfAYqaMtjokSWxKxt
         o/JN9qzdw6OB7WtqWPVgHZWC5bAmpvIdAgo1oRY6jN9u2bcsqXHvsl8sBIMAUskKPpaW
         UZmNgWHaHEBzduwtQxo+HxCkLA+2Vayzb278jGxV2aRXW2wNBcgiPT4dgLDlrUMKGgSb
         L6caQtiE/tmAJ5ZYi8jCm9v+iaklqkd3UI2UAocThUdHG9hXPYNe4gAik8Vk1oTW8rDg
         mhlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793644619; x=1794249419;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1u8rN1C+JF6DQIQz6Nin0TnpQFmY/6RtXJ4cFBXNPgw=;
        b=jir5I0hO9oEUEt+Vs8USHwdIHkGqN1mn1xUSlUmyA6ROLrjxDXN8LH04cFKl6OTPV0
         WKI+1E7oXmCCRC+KrLO7vGwyQ1/YGikVlkpd6SZm/OQHxUblWlAWMNNYeoqttfA8a1xm
         YyXMAdVBGAxxoO8ATRMA9O4JnK1smlkEpO6VUW0+fF7zXUgLkOzzPBZSiCDmMZWtBVbO
         8PETnxA/1kCca+HEZ4DPJP+P1jDhSVImUi/KmeKsEm53R+grUboWq8GCrhhF1g3n/c5/
         njKFaQcVo1CElLVrQmcJKoxZrFM2n4ZMGwBbD5cOViz0r0oyzXoKqEYeWoRHRtMnLsuc
         BKXw==
X-Forwarded-Encrypted: i=1; AKwUvBy+mYsvynl375+QuGCVtz8yA3YRXgg7YhnOPGHLXq/eyoOxCp/UvrePKuJCTX388pdDUyqo34XhtsgytFk=@vger.kernel.org
X-Gm-Message-State: AFq9FYJCJOC4e0z16CDS7UDtf0OR2CNaZPTpULgRCgQzKi4QBMr4Du3+
	4s240VEh7kYt/6Z6dZFXKIBph4xw4l2Jg+uK6og+I9f3DwWvJADA3mv67y9g5hpaH29+AhGm+ag
	wWr1okqcfxUm8/RvG+gIoT1qAZZVVzqcGFG4UigpW
X-Gm-Gg: AYBFou27r7zOv/bq64y9/CkWy4fcLQlu2lqAT3+eL6Y0WJTMoKk4O1I5gPAVu0Pw5oF
	cFwI5MquJFw1Ex+GhczFqwKVR7ESONnjf/FxvNZyxlCpsxNvs2DSKYTqFRxFnkNSjIDPvU42eUF
	VmHVA3ZqqF5kA4QnJCD0dHPQvGb9GehjQ5/7yv0jDpAkb+GS82uTc0tVoXPCCd3yKlK2D1W0UI1
	fefoxUhlJtD/cOTE9hegSvQn9BxhffWPZi3ZkAvHIn4q7dXAx9xmuoZBL4XFPgtJ0tfEhNqHzBQ
	cIFsPImxqQMMjgKYPMttkyJuMdUliz3cYbo0TobVlSNq1wmplnJ2rd5OkDXQ3gqpMq3WN2x6p6G
	WUJ5MeWMYrjEW0i3QuxmF+hYI8FsnW36WLQri3mrEmfwqdu+OVm0igCm2DW5N4pR++gJjT4pjQh
	eZVIjxWuvAe9dWblLG7XZzfA==
X-Received: by 2002:a05:620a:f06:b0:93e:e1fd:b87f with SMTP id
 af79cd13be357-944218343ecmr1679226985a.83.1793644618379; Mon, 02 Nov 2026
 10:36:58 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 2 Nov 2026 10:36:57 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20261021192434.1924950-1-michael.roth@amd.com>
References: <20261021192434.1924950-1-michael.roth@amd.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Mon, 2 Nov 2026 10:36:57 -0800
X-Gm-Features: AclHuK_agTkYa972bVKqm46_s0pV5Ox5h2f_yc6g3dcOXiVBLMEAsjmaUCTk6Ew
Message-ID: <CAEvNRgEgz+oAq2MsPXP=PLfuoR798NjMbv9owjXhMHwkXzqCCg@mail.gmail.com>
Subject: Re: [PATCH v3 0/1] crypto: ccp - Make sev_cmd_mutex more granular
To: Michael Roth <michael.roth@amd.com>, linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, thomas.lendacky@amd.com, 
	ashish.kalra@amd.com, aik@amd.com, seanjc@google.com, pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"

>
> [...snip...]
>
> OVERVIEW
> --------
>
> The current code makes very coarse usage of the sev_cmd_mutex; for SEV
> firmware ioctls, it is essentially taken upon entry, and ends up wrapping
> a lot of potentially time-consuming prep/cleanup work that may need to be
> done before/after issuing the actual firmware call, which is the main
> thing the mutex is meant to protect.
>
> Additionally, some of that prep work involves
> copy_from_user()/copy_to_user() calls which can generate page faults and
> unecessarily lead to potential deadlock scenarios. No known case exists
> in current upstream, but with the upcoming KVM/guest_memfd support for
> in-place conversion of the same PFN between shared/private state (which
> is currently targeted for kernel 7.4), a special fault handler is added
> that could theoretically deadlock if a malicious user tries to use
> guest_memfd pages as the source/target of target of said
> copy_from_user()/copy_to_user() scenarios[1].
>
> So this series is a prereq to enabling the above-mentioned KVM/guest_memfd
> in-place conversion support on SNP-enabled hosts, as well as a cleanup
> for SEV ioctls in general.
>

Thanks Michael, Sean, and Tom!

Herbert, does this patch look okay to merge for 7.4? If not, we'd need
to go for Plan B, to test/figure out mutually excluding SNP and
guest_memfd in-place conversions for 7.4.

Thank you!

>
> [...snip...]
>
