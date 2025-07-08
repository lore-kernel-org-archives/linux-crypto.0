Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01FF1D5CD1
	for <linux-crypto@vger.kernel.org>; Tue,  8 Jul 2025 13:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751983049; cv=none; b=cNsEwPpvoV8nh8yihBVXeTrrvF+99SpEoZGENu9fv2MZvr5tFaiOoQchpv85UNJGY/qu5yGcAXk05L6u/J7TgZsHLqyDWXAUh9bebKVpCJC6G0p2VPsuQ2Qf7Qd7SND2he1xppKHh5+2AtKfEDCvXpr1Hlej5GMjr1bBYoUUSew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751983049; c=relaxed/simple;
	bh=nPRkDhL8E8FLJgw9wpJ0thNzlbfwD6v+mQ913tqnuuA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZHYREx+ixTy+zbxsUOpeTLh/z5E+10sOxmqSgPs2LAxpEHqLgPb0UCiwM1o9PG45KVmsYy8jAQqG8BN/HGu7kuB5ALIuEL2AEMDrqmOwa+eVhQPnTbaE5mYyw3CUJQVgf3TcXXaRuiC+uM/+qZB53NSlUhFc6mG+AFsqavSPj2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vRNhcB5O; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vRNhcB5O"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b2c37558eccso3636396a12.1
        for <linux-crypto@vger.kernel.org>; Tue, 08 Jul 2025 06:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751983047; x=1752587847; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sdvTyjqYr6DeaDgKOWQo4ceHkkEpBJ7epWuJUuKuI6Y=;
        b=vRNhcB5OuDB10XX+cpoeOs5dd6iWR6dwCvO3Xl8TRXrRR0Vm+KBv0S0zbcYtZV68OO
         VJ2zuWtDVwf3T7JuPVJgt1mWQEsJ4WMonGKobPBDRrwbL0AS85fIXzMMVG+r6mLtXFXO
         YKP785nVmGgAgW6a6d4SHMXu+kz5fZgX+ax2+LgHOCZ5DZSf29rXUhMeuU8QcRl3HLX0
         lqfZVrfhDBskNyy+G6jFwa5PRVuBwaG4eJF9KX3nQ8s/PLaxvmrNhamzMcvJFTt/fl9z
         GC+WqjLmuI7E8D7f3NrfirUB0gxQI2SJhJK6EW0qr3vockDx2AlCeXBapIa3NS1wg2Wo
         gF8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751983047; x=1752587847;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sdvTyjqYr6DeaDgKOWQo4ceHkkEpBJ7epWuJUuKuI6Y=;
        b=u43am+vkncRm8d4gS927jzJ+4doCEDNF8ueZmQ7em4EtXMZbVNBAj6TCw8BaaavKiO
         ihTN9vdjoEKfvkLoXTVDlDpyqmzJof9OA21TF8QIsaGZ2DRKLiqogqvQsBJlcWugV94d
         8PC/k1xyqBzPrtZtUzEy1DtbLujKuz/zxRpeouY1Ee8jdic4G0ZwT8bZ33If/r3BK2Jl
         JBEWgUH/hsjVgwRyfsaJ16/00LjsepgllSShXy5eP4EcwPqPzjD6I+T+XxwWgMEf+AeF
         A6caLZiwhV7+JQkoKxAHRCMAItjkA7tjLgXsQPnbQ1zhG2GYH50kChZQAU3s8fbgXENo
         u/Lw==
X-Gm-Message-State: AOJu0YzmwLVn6r0Is1lCBRizmXUzQAXBE4qqk+YCo0IjdcLb7MIGDO4g
	xlEgx/U2SiThS85LYaoLODIhUh13BTBtOpO0/SAQ9szeiyvy7RBQbSB5HQ9Fvzh5dD8GwIU/ddw
	30ItGdA==
X-Google-Smtp-Source: AGHT+IHvdv+w29JSPihODhDIee7swDtvAX2IYS/fubnAofC1vgqJOZEFvsm7ndwvcPF9stQjHS2WwipJL5I=
X-Received: from pfav2.prod.google.com ([2002:a05:6a00:ab02:b0:746:22b3:4c0d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:998b:b0:21a:eb6a:b84b
 with SMTP id adf61e73a8af0-22b4497b4f7mr5350580637.30.1751983047247; Tue, 08
 Jul 2025 06:57:27 -0700 (PDT)
Date: Tue, 8 Jul 2025 06:57:25 -0700
In-Reply-To: <20250630202319.56331-2-prsampat@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250630202319.56331-1-prsampat@amd.com> <20250630202319.56331-2-prsampat@amd.com>
Message-ID: <aG0jxWk1eor1A_Gd@google.com>
Subject: Re: [PATCH 1/1] crypto: ccp - Add the SNP_VERIFY_MITIGATION command
From: Sean Christopherson <seanjc@google.com>
To: "Pratik R. Sampat" <prsampat@amd.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ashish.kalra@amd.com, thomas.lendacky@amd.com, john.allen@amd.com, 
	herbert@gondor.apana.org.au, bp@alien8.de, michael.roth@amd.com, aik@amd.com, 
	pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Jun 30, 2025, Pratik R. Sampat wrote:
> The SEV-SNP firmware provides the SNP_VERIFY_MITIGATION command, which
> can be used to query the status of currently supported vulnerability
> mitigations and to initiate mitigations within the firmware.
> 
> See SEV-SNP Firmware ABI specifications 1.58, SNP_VERIFY_MITIGATION for
> more details.

Nothing here explains why this needs to be exposed directly to userspace.
