Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377CE44CAED;
	Thu, 26 Feb 2026 20:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772139564; cv=none; b=FsylgrEv5C1Ehhf8PmfjWFdruICluaQ+ZUzXhobbKrnXku7miZxhmRCsNONx/4VlNUSbSh2vTJ4kVO0mrjlmJHydH8liMye/qKZXPzE9S/u+xI2MVlMv5Ez2gIugtZVCFMmzEafg8Lba8TXsJjtrNzdP2Zt0FWsduA1poiOMpfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772139564; c=relaxed/simple;
	bh=qWBjnKxweipSLzAbTf4M/P9qFFraSj8HuEvZL4idUcU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ck1Qk9MCHzemEzVROkZCzaxtdtgVb6+5yc5E5avl1m5Atz+qvMqnWJuCiLYQMQ4qM0Lb8cRgZ8cgGFi19+WtTZk7VZqHFq1+UgJTTXRtpjjfqAMBvT3Yu0Pt99cUEOt4wVMuWsAe1tUANnlXxMlqzFsPtjbw0FlfgfRY/FWEMvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D+lZWLBM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D+lZWLBM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D38C19425;
	Thu, 26 Feb 2026 20:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772139563;
	bh=qWBjnKxweipSLzAbTf4M/P9qFFraSj8HuEvZL4idUcU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D+lZWLBM7gwe7s3XKtau6bIucSKnJVNqG9MJAmoOrDoelvSi2qQDK04i97S3vT8RM
	 j3Px6vTrnh0aizTfll9s/sbZ7gfjqLyND/GZ9SUbDkdVR4CFvUYU1oxuNGzQpV+ZPZ
	 ClC0nm+ZYaHHwHPFSssfN09y1cxah8Notl4S6lWpDVRsVWzoWIFptiitA2g8YIGS3Z
	 Ic45V6/uw0fsdsclo7PlQGyg4iDtdav+6LCV2rrcaPOHKCoHfX1Dxo/XUqU0r/yQBu
	 N+cFNBSHh16nmm4r86pwNYSxaA16wcQa5wiLclskp2TLyxQomgIq96RuBysWbvJvLK
	 0xEQfxYTA6sGw==
Date: Thu, 26 Feb 2026 13:59:20 -0700
From: Tycho Andersen <tycho@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 2/4] selftests/kvm: check that SEV-ES VMs are allowed in
 SEV-SNP mode
Message-ID: <aaC0KGXmfhOMOrJ9@tycho.pizza>
References: <20260223162900.772669-1-tycho@kernel.org>
 <20260223162900.772669-3-tycho@kernel.org>
 <aZyCEBo07EHw2Prk@google.com>
 <aZyE4zvPtujZ4-6X@tycho.pizza>
 <aZyLIWtffvEnmtYh@google.com>
 <aZzQy7c8VqCaZ_fE@tycho.pizza>
 <aZ3ntHUPXNTNoyx2@google.com>
 <aZ8xje-iM0_9ACie@tycho.pizza>
 <aZ8077EfpxRGmT-O@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ8077EfpxRGmT-O@google.com>

On Wed, Feb 25, 2026 at 09:44:15AM -0800, Sean Christopherson wrote:
> Ya, I don't have a better idea.  Bleeding VM types into the CCP driver might be
> a bit wonky, though I guess it is uAPI so it's certainly not a KVM-internal detail.

Turns out this approach breaks the selftests, which is at least one
userspace:

# ./sev_init2_tests
Random seed: 0x6b8b4567
==== Test Assertion Failure ====
  x86/sev_init2_tests.c:141: have_sev_es == !!(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SEV_ES_VM))
  pid=12498 tid=12498 errno=0 - Success
     1	0x0000000000402747: main at sev_init2_tests.c:141 (discriminator 2)
     2	0x00007f9adae2a1c9: ?? ??:0
     3	0x00007f9adae2a28a: ?? ??:0
     4	0x0000000000402934: _start at ??:?
  sev-es: KVM_CAP_VM_TYPES (15) does not match cpuid (checking 8)

As near as I can tell qemu doesn't do the same anywhere. SNP guests
run fine, and SEV-ES says something reasonable:

qemu-system-x86_64: sev_launch_start: LAUNCH_START ret=1 fw_error=21 'Feature not supported'
qemu-system-x86_64: sev_common_kvm_init: failed to create encryption context
qemu-system-x86_64: failed to initialize kvm: Operation not permitted

Thoughts?

Tycho
