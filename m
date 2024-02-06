Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7741B81D
	for <linux-crypto@vger.kernel.org>; Tue,  6 Feb 2024 20:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707252717; cv=none; b=quvwEQSDJHGTmrzCaBlYcMemVr+baR+LZK3uFtd7KBtMWtPszOnt2B6hL/DAr9VpPynQyPyV5zteFUlbgMefRbGqrWA/stq5WsvUNA7LzZAxcy08dUDZEsS+QseKxtcp1f7xAA/+T+4LDUrfWXcg2Di6wDw71kLaQUKdcAG6i5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707252717; c=relaxed/simple;
	bh=6f6Qix6f+UWdfRaPzaX+crwa5ujk+FHt0PxZzVbTk2g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rEZrniUGT6Moo1VMKcW4FP8hP0raMRu42wVQLC86KTOHaza+GgxLVbS3AHkmHoSBSKx4AQJENdLyQSvWs+KKy5OvcGLsc/Dq5NcBfo2R0MO66ffLCftyc8ZDlTMTErKhT8DUaQYZ1cRPQjKt+tU5fHMMW1rOYGBmJ3Gmxcf8Wow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dI8Pt14l; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dI8Pt14l"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1d932f1c0fbso53373675ad.0
        for <linux-crypto@vger.kernel.org>; Tue, 06 Feb 2024 12:51:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707252715; x=1707857515; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JwbhYZHR4hW4due82eTme97f04XbIaf6d9EPvYJz5x8=;
        b=dI8Pt14laIQ7hBtZ4OceMWEWk73T+qoQFwNDRfujpMULS2qQ3zE2nHvSgOdOYnMj/x
         CbVmjX9PDgmYvHmJMn4fga1zIlMhGGpBIkxq9Y8NSTUXw+mUwEUFsMLuaKK4e9GXuP7L
         bH7aehGXGXBDMjCuq50hQavYfnBkZwiuLIljg/J9Jq0HtIhr/uvxI0TTUGftUYyDTiXP
         DsZe1YQXAZmVrkczc+ONBLcW8/GeFLtAPtSYhPl2WaELuTORixaW4rqz490qymc0xCU1
         c2tXvptlq6VrfQ56D/AHIuA3WvRm9Iwxf/fu2Umj1S9U4ivrWph52epJx5HE/Ag/M9IM
         +zBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707252715; x=1707857515;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JwbhYZHR4hW4due82eTme97f04XbIaf6d9EPvYJz5x8=;
        b=Je2me1HX26mTVobbT/S5unuEtI0iw/1j6vDVjdWoRE1zJCVfblPB4L7SKMdizNrq9A
         YBBO0mY1cxk72gl5QRF3l/XftUqRi8ZzMAho7AOambgcBdV9XvW7lUikPR9HganMtl0g
         v9oKRhEnTry7TE+UjQbXqsQFPU5kmtISpUw10TMa7qKtgDUFgyDS0/m8NELYDvitM1r8
         VrErjDBTgPi28u1GsFFwzHdiVwQtquTCP3QWukEzgbIDlEY/Zrv2BA3mH6j4Wv3CQ1dk
         4i3/ZOcBbInecDCrcPtsKhTa7Vy7NTsGeRY7yWQlU9MmbWI8cIaE36fElbgM5ubR5AH9
         QWQA==
X-Gm-Message-State: AOJu0Yz0YVJH5IC+Qf9Uu25zzMWe0gR7FfhLdsMLjeXmXQcuT1ObnrDh
	Y9DxN2Ua6SwtxSmX4J3vr/H5ZByrPT97EVbj4nWmvalC5RHapG7vokO11Tk5+0DxbW2pEvFtK6b
	n5Q==
X-Google-Smtp-Source: AGHT+IEj5phGVut6P7UH0HGT2jn7IqSaGP6JthmOgqjg9ZskUGjauEK3HLRpFSTg5biILz4Q+Ty+BMdRsZg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d510:b0:1d9:ae91:7b50 with SMTP id
 b16-20020a170902d51000b001d9ae917b50mr8028plg.7.1707252715474; Tue, 06 Feb
 2024 12:51:55 -0800 (PST)
Date: Tue, 6 Feb 2024 12:51:53 -0800
In-Reply-To: <20231230172351.574091-7-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231230172351.574091-1-michael.roth@amd.com> <20231230172351.574091-7-michael.roth@amd.com>
Message-ID: <ZcKb6VGbNZHlQkzg@google.com>
Subject: Re: [PATCH v11 06/35] KVM: x86/mmu: Pass around full 64-bit error
 code for KVM page faults
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, 
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, pbonzini@redhat.com, 
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Sat, Dec 30, 2023, Michael Roth wrote:
> In some cases the full 64-bit error code for the KVM page fault will be
> needed to determine things like whether or not a fault was for a private
> or shared guest page, so update related code to accept the full 64-bit
> value so it can be plumbed all the way through to where it is needed.
> 
> The accessors of fault->error_code are changed as follows:
> 
> - FNAME(page_fault): change to explicitly use lower_32_bits() since that
>                      is no longer done in kvm_mmu_page_fault()
> - kvm_mmu_page_fault(): explicit mask with PFERR_RSVD_MASK,
>                         PFERR_NESTED_GUEST_PAGE
> - mmutrace: changed u32 -> u64
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Link: https://lore.kernel.org/kvm/20230612042559.375660-1-michael.roth@amd.com/T/#mbd0b20c9a2cf50319d5d2a27b63f73c772112076
> [mdr: drop references/changes to code not in current gmem tree, update
>       commit message]
> Signed-off-by: Michael Roth <michael.roth@amd.com>

I assume Isaku is the original author?  If so, that's missing from this patch.
