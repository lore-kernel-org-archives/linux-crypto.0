Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792593553;
	b=EAyG03617ZQvHVWKfibUbnELxAKHRIe2pOQUpv5FbOavYMp6qMgpJjdWuVVRn9ve3heU
	 bPPBRHqJVzx5Vj/uRLlHMPvkpeIgfpjfVOeoJAdnOEr1UtpvKYK+EC3CYDML/WQlvoaYs
	 YszfQIlmVo9pNuhZsvOIebMJUbdlSQPrxuMcgFACxCiVLMzYT7EOdGzrrHIjdNzoyFnF+
	 2ppWWkVX2Qne0GYR5BnrS+g76EVduBDbq/H/1ZZeVKlFFUI7ymquNLNmkA+pIQgMvmQel
	 4wHWEp97VX1ci5DR5Vm0bVzdpxWg3Q9gkzatSuYKpu6DLbwo9tW8w1mMPSFZo22+DIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792593553;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=dHHSyx8epIsJnuDzCGymw7BujPaFlfYYUjbdYU2ao2s=;
	b=MCfnKwHHpImz+/VvTAf+jVLjt6WuMFJBlFW5gOgao+IaxHBhw5A4DDMz++j8eulu+iYl
	 CH4B2HRhh2j9rrPkxLIjmVXO3Tb3FhNlsuWlyPWfawpPaTwBXuNXygFj2X49oYOdpMqrb
	 5dV0jPLe7aEwe9uhV93qG76iL3lSQqe+VpnJ1OeTvCIqL2oPU6rUxINp6OBDPBvZgY0rr
	 nS/NEqf95rFBOKEOJnGD2KmxjqwgbJtShNphwZNxT7Rv0icZOZ9EyDjSuDoLeBr6jmgGh
	 CzBowk0spu04DKA5KsSuQml/fkf2mWy+CEoYDc9XcIp/we5iVragnbrc5rvAZyynvwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=DS1mfXdO;
	arc=none smtp.remote-ip=209.85.214.198
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CED606A319
	for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 14:39:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98CED606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=DS1mfXdO
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2e94f72fb9fso7388935ad.1
        for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 07:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792593552; x=1793198352; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dHHSyx8epIsJnuDzCGymw7BujPaFlfYYUjbdYU2ao2s=;
        b=DS1mfXdObDY6FKJV1yvA64gnxoZu+cc6CJCOHREAU/KZsFElGTUKynVvQcu3PLjmgi
         JqAXumj57ivTMiQma+KLgqX3CxGfjkqBpKHas2sN7fynzBbWVCer386OW1/4GMlFbtpK
         UQ3dHhzVR4nQbdzfBGGtqBKd/jHwEwT5KxmyHpBNwpAzsxzLyLsIn+LYY8Eo5lh8RmYY
         An3mR1cTzXAOSRtKhjAhFwZ5bYiaZiilEsU78x93QYAp/rYKwbmV/yNA30uDK6AMlnT6
         pnvBBbK+5pYjysbP4xN5T5eCCl5nHemdg+0+1re5/NFcA1cxw58AIEQsGCt7xsGpqcF0
         M3Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792593552; x=1793198352;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dHHSyx8epIsJnuDzCGymw7BujPaFlfYYUjbdYU2ao2s=;
        b=bcT0u8+T/p22Vxo1hl+mOd96rSS2oizUpakqOuwxOJFCTiFIbGU+IWFg/YyCEd9UPR
         vqYR51dpkHZO5gHHxXRbQIhkZUmsGCoTOGWIwvqIFonK7gP5oACgaYqvF30XpzFnYenT
         xsqwDtG2F1XvCc3kV0k1Wd53/+pcA2zGWS0/th71qkjiIF0Bj6hbtOuMXTyG6agY4mmw
         1bFLM1CDA0bIpq1LWDjVsdCJkqVBLfz4svUckp7zmTusukK5toLZPc0Bj8B3hRDb6gWM
         J+WUxUqjiibnek7aebBIGglpblTOkbm1XpI0u7Z7pVhapWyyGfaqFogo7lGEpq+r9NhG
         7uiw==
X-Forwarded-Encrypted: i=1; AKwUvBwRz6LJLZjTz9t/21HCwl699gTN9PqeWFHshOJAvcm56CPjDxTn+gvq09YjmPADJe1Y0omLg2N8O7OWCa4=@vger.kernel.org
X-Gm-Message-State: AFq9FYKWUCCUPpVoT8d4J6ikCQLSwNGv+h9WqVno1FvbMEoJcpfC6aQ5
	CiriSPQfr8dhak7kv+LZkanAP6EEhH8Vr6wbumBZMxVTTy1yr8pZ1t8uXF6eR2wNLw+OKmlsKjv
	a+W1MPw==
X-Received: from plcm12.prod.google.com ([2002:a17:902:f20c:b0:2e8:8068:eebe])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d552:b0:2e9:5714:608b
 with SMTP id d9443c01a7336-2ea43e0a788mr19464755ad.34.1792593551531; Wed, 21
 Oct 2026 07:39:11 -0700 (PDT)
Date: Wed, 21 Oct 2026 07:39:10 -0700
In-Reply-To: <athNHhrMegveNJBU@gondor.apana.org.au>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261016041109.1778673-1-michael.roth@amd.com>
 <4snves2iefswr3cnswjllztvjwmm5mw72ns4krsbslioq6buaz@j3zovm5cmewd> <athNHhrMegveNJBU@gondor.apana.org.au>
Message-ID: <atjOjlPKWuSjFFXx@google.com>
Subject: Re: [PATCH v2 0/9] crypto: ccp - Make sev_cmd_mutex more granular
From: Sean Christopherson <seanjc@google.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Michael Roth <michael.roth@amd.com>, linux-crypto@vger.kernel.org, davem@davemloft.net, 
	ackerleytng@google.com, thomas.lendacky@amd.com, ashish.kalra@amd.com, 
	aik@amd.com, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

+Paolo

On Wed, Oct 21, 2026, Herbert Xu wrote:
> On Tue, Oct 20, 2026 at 04:42:19PM -0500, Michael Roth wrote:
> >
> > Hi Herbert,
> > 
> > It looks like the above-mentioned KVM patches are queued for 7.4, so these
> > CCP fixes would be needed to avoid the above-mentioned deadlock scenario
> > with KVM.
> > 
> > Would it be possible to get these CCP fixups in for 7.4?
> 
> Sorry, these patches are too big and too late for 7.4.
> 
> If there is a specific bug that must be fixed in 7.4, please
> post a minimal fix for it without including the refactoring.

I'm with Herbert on this one, the "Use __free() handlers" refactorings in particular
strike me as unnecessary for the "fix", especially since __free() can have some
nasty gotchas with respect to ordering.  It seems like it should be doable to go
with a smaller (though still non-trivial) set of changes for 7.4, and then do the
fancy cleanups on top for 7.5.

If making sev_cmd_mutex usage more granular is itself too much for 7.4, the
the alternative is to disable/disallow SNP if guest_memfd in-place conversion is
enabled.  I personally don't care terribly if SNP and in-place conversion are
mutually exclusive for one kernel release, but I also don't have a vested interest
in any particular upstream kernel.  Well, unless 7.4 ends up being the next LTS
(but I don't think it will be?), in which case I would push very hard for landing
the mutex changes.
