Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FA6158A0B
	for <linux-crypto@vger.kernel.org>; Fri, 31 May 2024 13:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717161062; cv=none; b=iVtp8pv0qkARYNIJUh4JJTkPvVMmWaAQk5rzr8YKm4dy7BeZaAZpi/0UVWAEUoIdRlLDnYROYmZbUjWQNKyefiQ809oXFtrl4rmruVHj8t1WWc1KIdtIOC1NVytjjkBNU5RN/rgIjKYe2r9XOOAkZcQwfsnDWZxN/8vKmMVZoyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717161062; c=relaxed/simple;
	bh=CqLmmdZ2wecXUVkHp+HXQRJLjMCpZYdCiUOYNmrEQ+o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UbNst+hTYpVmuXbuSQaSUoAgSiOVQkZo9aG3Leu42cPrCeXMKbXVj6bbHbSi89kxZm1yTndf2OWd3uS3NgZUkI3NBNA73Ns9SJXs6kzcyvaRYBgL9v6lOeQjYhYJ3Te8fdx3rRzxJJmz0wZA7iEtd1JhTxrlBnvFWXNog6CRtE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=avsy/iqc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="avsy/iqc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717161059;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CqLmmdZ2wecXUVkHp+HXQRJLjMCpZYdCiUOYNmrEQ+o=;
	b=avsy/iqcjV14RBcHBxlLBdgoRdsEUarlefrW9J6f5M4/LlKD+Ox9ECL/wANBTJwJ6hpHzs
	KekWSiv4iFQbdIwizRk4jowc7PYLbpvE6yEn6ApmtLuNdKnourO78CjplLyc3iSjPUxGMa
	+4+bu7D7HyLYPLDHfGhxa3YRvhr7t+0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-378-Lil9rp33MCCOHTlEwkXX2g-1; Fri, 31 May 2024 09:10:58 -0400
X-MC-Unique: Lil9rp33MCCOHTlEwkXX2g-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-35dca4a8f2dso1044127f8f.3
        for <linux-crypto@vger.kernel.org>; Fri, 31 May 2024 06:10:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717161057; x=1717765857;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CqLmmdZ2wecXUVkHp+HXQRJLjMCpZYdCiUOYNmrEQ+o=;
        b=WnQwDq6z54nU9WQXkFOM7bsCLnZkbfcO7oMEOFbJCVjimCTBeuzzEeHR8o/1P9ND5c
         3gsiTor1HSTwuAb6KH8uwveoB+MnVzbm0Dgv82at1ULR7VZY9MARqNgQjZdpKEZsZsvm
         xG/p82YbA9yCPfeNmxyGfExnwrNT4Y2HMVMYp1RPrleb2Re7vRBNEh9oaGccjpk//Vb6
         4K5J4v33SdDrsqgvT5GLIVKY3fSfV5zxRnPNW5WAhAAWkP9v1xxVMHTPdGCSiubc68Q8
         xK+JEgCOYuRU8y1TsIyRN/2aHRH4hwYIFmxbLhJr+PW1ZOEPYhntRMWsekd1LUzAPNC1
         gKEQ==
X-Forwarded-Encrypted: i=1; AJvYcCXBW3hST8EINzH1H6+Yzh7NhhxoMM78rlX00p6JrsFpGN9QIrzflMZny5GD7PNFq7NAIZffj1WKK7/rbrDD0UxY/ZEoujFEYvVq6mNy
X-Gm-Message-State: AOJu0YysyCH5KUlmYi/o+WG9F+7JGwIYdC/bJQfv+iSUKPIhm6o6lNG+
	Y1PyAPfSE7CZfHEetmAaTF3+0uEi4pqxaxFBF5OALlJJVQGl3a4Wr0n4pOgYsDQ6V5lDum2gKao
	egZ31B6HOAPswUEDJeB2o07fm2riXKt7eMaPdnviRobWJRHm6tVs/JEwMx7px6o22qYtLV5bi65
	iSv9x6UVZvFTFgtn44SZtkN3VOywS6TOVdXiPH
X-Received: by 2002:a5d:4bd1:0:b0:354:e0e8:33ea with SMTP id ffacd0b85a97d-35e0f37119cmr1303099f8f.66.1717161056774;
        Fri, 31 May 2024 06:10:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG3gzv4GfxGaWcm8XMVixs3+MtMYgeFKTzpnPkZZHcTWqGRUOOsjVrY6Fxl3SCwOqZe8dfStn6ygQ2HzwmiDVA=
X-Received: by 2002:a5d:4bd1:0:b0:354:e0e8:33ea with SMTP id
 ffacd0b85a97d-35e0f37119cmr1303068f8f.66.1717161056377; Fri, 31 May 2024
 06:10:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240501085210.2213060-1-michael.roth@amd.com>
 <20240501085210.2213060-10-michael.roth@amd.com> <84e8460d-f8e7-46d7-a274-90ea7aec2203@linux.intel.com>
 <CABgObfaXmMUYHEuK+D+2E9pybKMJqGZsKB033X1aOSQHSEqqVA@mail.gmail.com>
 <7d6a4320-89f5-48ce-95ff-54b00e7e9597@linux.intel.com> <rczrxq3lhqguarwh4cwxwa35j5riiagbilcw32oaxd7aqpyaq7@6bqrqn6ontba>
 <7da9c4a3-8597-44aa-a7ad-cc2bd2a85024@linux.intel.com> <CABgObfajCDkbDbK6-QyZABGTh=5rmE5q3ifvHfZD1A2Z+u0v3A@mail.gmail.com>
 <ZleJvmCawKqmpFIa@google.com> <3999aadf-92a8-43f9-8d9d-84aa47e7d1ae@linux.intel.com>
In-Reply-To: <3999aadf-92a8-43f9-8d9d-84aa47e7d1ae@linux.intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 31 May 2024 15:10:43 +0200
Message-ID: <CABgObfZZsJxQ5AKve+GYJiUB0cFc70qkDbvRB82KrvHvM0k3jg@mail.gmail.com>
Subject: Re: [PATCH v15 09/20] KVM: SEV: Add support to handle MSR based Page
 State Change VMGEXIT
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org, 
	linux-coco@lists.linux.dev, linux-mm@kvack.org, linux-crypto@vger.kernel.org, 
	x86@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de, 
	mingo@redhat.com, jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com, 
	ardb@kernel.org, vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, 
	Brijesh Singh <brijesh.singh@amd.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 31, 2024 at 3:23=E2=80=AFAM Binbin Wu <binbin.wu@linux.intel.co=
m> wrote:
> About the chunk size, if it is too small, it will increase the cost of
> kernel/userspace context switches.
> Maybe 2MB?

Yeah, 2MB sounds right.

Paolo

