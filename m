Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698354BA85
	for <linux-crypto@vger.kernel.org>; Wed, 10 Jan 2024 14:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YRqAitOm"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1d455b34723so39282095ad.0
        for <linux-crypto@vger.kernel.org>; Wed, 10 Jan 2024 06:59:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704898798; x=1705503598; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jQgwaFhg2BKv9e1KoNKcmXpgVYtZET9cMV48SEG0pPU=;
        b=YRqAitOm5gumBrFgSLai4ponlmBBw6BKjFm3Z6tU5tFzOvbrG5T3GgqztmunDZUxvD
         h+XP1+AruxU5dtviaLIS7fSxjTqOmXpHhwQTLY2zAXmD9YnSUnmFMX931gjUrRbfWOkv
         7pUMeM1rCs6RQf0KgyOi7ihga0yB/mAs4cNnze3nq2R1fHzyfsTtawinpREtZ1dN0fNJ
         5azrmjfK5AvS1K6SjMETx0oa/dvTT0gE8EQon+KQNgo3X9Udjj82Tayf+qWnJPgrfR+/
         tSlmizaajvR6GBC8gcJh2JVVK3HLbHWeaPEXE9GHH6LLLl5jdTX4Ko+b4TbJq5I+gu8z
         TOfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704898798; x=1705503598;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jQgwaFhg2BKv9e1KoNKcmXpgVYtZET9cMV48SEG0pPU=;
        b=wvNW7/+ilRvFJOg6sVYNyPwGpowdD9nijAaM0IJ5ZZ21uWteXheHfFK7iDeY0Zj20D
         9Fbr+y873e3ZqzTpsR2vWZXayvckGfbd/q/UlemtnQqUiU4v+NU4vNeaDts2ALMIHgVY
         6Iiy5wxgrW5ZHHyA7XEYiA4VYYKTVL1Qh/k5LRrIHHyWn1x5JNwduGQLuKjAaEEpxwGr
         ZAiEl/d8ReISOvE92xOZ+ZpYG5y8V9Dkj6PGUdOpMU/OQpYlpt5aD2/fszQXfzGxg11u
         Bikv5SoWOrLyv4lLVNdMdccha3KIFuxfQ7yd7PpA0wB6fAA3E4R7SRQ0IB0rtNFXs2Wq
         /Fsw==
X-Gm-Message-State: AOJu0Yz6xPpF6IcMqLjNh7f/dNgBNRKXf0ZD6Y8NvZM658Wokp3ibAUI
	aHwg55k9U2WQyNwAaeiO0j8UUSK0ALfl7O/Ugw==
X-Google-Smtp-Source: AGHT+IEFhpLTQv5FIWQpxWjgo1MFihEctBgRDmmwpll2k+f+nuyvSydHAURFUngl8/4pjVhHXFBidN6ogTw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:cec1:b0:1d4:a996:fc96 with SMTP id
 d1-20020a170902cec100b001d4a996fc96mr6121plg.11.1704898797659; Wed, 10 Jan
 2024 06:59:57 -0800 (PST)
Date: Wed, 10 Jan 2024 06:59:56 -0800
In-Reply-To: <20231230161954.569267-21-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231230161954.569267-1-michael.roth@amd.com> <20231230161954.569267-21-michael.roth@amd.com>
Message-ID: <ZZ6w7A8SYz3_VT3u@google.com>
Subject: Re: [PATCH v1 20/26] crypto: ccp: Add debug support for decrypting pages
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-mm@kvack.org, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, 
	pbonzini@redhat.com, vkuznets@redhat.com, jmattson@google.com, 
	luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com, 
	pgonda@google.com, peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, tobin@ibm.com, bp@alien8.de, vbabka@suse.cz, 
	kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com, 
	Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Sat, Dec 30, 2023, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> Add support to decrypt guest encrypted memory. These API interfaces can
> be used for example to dump VMCBs on SNP guest exit.

By who?  Nothing in this series, or the KVM series, ever invokes
snp_guest_dbg_decrypt_page().
