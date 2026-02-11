Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF092F6910
	for <linux-crypto@vger.kernel.org>; Wed, 11 Feb 2026 16:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770828450; cv=none; b=ud9ccczmj7jbwI7ed8EPeSOEJE7Dmg6adVOikjWRIonosSxOXepTCigefCSoL7yQu/eHoq9BGj4RfRk2YBlAQi87185t0QznfLI6hl5TmYlWLGxe+4UGbWJYLNC76HMEB93cxSHTC4fD8PUUxAph2WTBfUfBeHNDLlH8/9kkL58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770828450; c=relaxed/simple;
	bh=6tT5JR2+mxZcE0qfU4XovEwaBeUCjefHu/HQsjDXXRQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k67TARPm+5TocGckPqfrhJDLSmqTonbz+ZioraguWEm6y4RTEUGMYiWyfoBiTC5ibFNCmavBO6rpk2Sls7j88GJwVGh63hV9Hd6x65BVIHaxOIgPTH5gZAntiUnHDyaprd5Y7NDt/FIlY2iGrlyBKLFIhNesnhNTKSVrkZW/aQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bUYm0Lvp; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bUYm0Lvp"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a94369653aso73107005ad.1
        for <linux-crypto@vger.kernel.org>; Wed, 11 Feb 2026 08:47:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770828448; x=1771433248; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BLVUVRl8y+39Clu7ugddgpxNZE8kBHF6JKudZmEKj7Y=;
        b=bUYm0Lvp8IfPdHyeguh1lQMA1ktHx9haKkfR+jd/yhjDCXZg3y6OVSwu5uRA3RIQ69
         q0gOled+wc+ilUFYV0B42IHHxKs7QiTk5Jt6430bmo4zUdTO2/iCXt88dcpVeoMwwckB
         6MFoOkIKmToSfR1F+kFg3WnaoCYumE+TWc5D7pk0LLiCHHQUkCfGf5vwZXrIkfHlldA1
         PIQuHGkCDjL3cgdfEwuAuhrvb9PP1PFX8sh7xvX/sZLuac+uKDWq05jDzIZQgIUHhQYC
         6tlUkTUCPKRtxrwGbG6CJm0JBFcJtMrm6P5aDAomzwz0zsEXbpzJYZGG3GSSBkodPFJd
         vwlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770828448; x=1771433248;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BLVUVRl8y+39Clu7ugddgpxNZE8kBHF6JKudZmEKj7Y=;
        b=o9UyKPXRYAZt8/TbvpqyxwJ3Lfx1aWObkcEzFAeb4wTYQa9iOUABqUReB4h58SRMKp
         7/EQ7Go6XmEwISz6bMeUotwhGwbfOIQh1bOz1DwXR3WWWj7FDMqsvmdG5ZJvBLYI7Xej
         B3+Xif782HsLc9/r0IucQAsvPLyZS1nxjbSPA57vwzyK5anW0PYvu285EeYOcqTNdbsy
         Mhv3HnGJhQOn8yqB3tx0oOabrzGnlENMqtAByqoXFwEOD9TJvwJ1N89h+6lekVdoTGNh
         cii2rqT6ZAjFr6XGxLuP7v1wdboxLQKj9qf3v3cJAiL8HDPp9gtD5FX0Kf5j+m6CWJ7n
         N52A==
X-Forwarded-Encrypted: i=1; AJvYcCXdySxxkIWC4Dgikp1NVzoWToNx5QhHnRsBw1hWoFAmjdWISKHxFBhnrPxaZ8xBR/k34aZs/78ty1i/MUw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGC/SA3qPzPM1TpCUOGKXkx/p4kJrSV83Dik7ee2dVj+/U0s7X
	dEte8R5pngISBMPxDqNRsc0772B9+lcxv40pTiLh27x7gV1U97rKdnceaquMRT7MVpUlg3FObFO
	fcSSklg==
X-Received: from pjqf3.prod.google.com ([2002:a17:90a:a783:b0:356:7a39:db8a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2d84:b0:354:bedf:8e64
 with SMTP id 98e67ed59e1d1-3568f2b7d65mr63493a91.5.1770828448379; Wed, 11 Feb
 2026 08:47:28 -0800 (PST)
Date: Wed, 11 Feb 2026 08:47:26 -0800
In-Reply-To: <421a20ea-2788-493d-8f25-497880c04a7e@thorondor.fr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260128194956.314678-1-thomas.courrege@thorondor.fr>
 <4d286692-3e29-4e8d-b6d9-f04ceb748499@thorondor.fr> <421a20ea-2788-493d-8f25-497880c04a7e@thorondor.fr>
Message-ID: <aYyynvi-alYQ1-_5@google.com>
Subject: Re: [PATCH v6 0/1] KVM: SEV: Add KVM_SEV_SNP_HV_REPORT_REQ command
From: Sean Christopherson <seanjc@google.com>
To: Thomas Courrege <thomas.courrege@thorondor.fr>
Cc: ashish.kalra@amd.com, thomas.lendacky@amd.com, kvm@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 11, 2026, Thomas Courrege wrote:
> Gentle ping

Sorry, we're in a merge window so this won't get any attention for at least several
weeks.  See Documentation/process/maintainer-kvm-x86.rst for details.
