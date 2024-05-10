Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C1717BA2
	for <linux-crypto@vger.kernel.org>; Fri, 10 May 2024 17:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715361952; cv=none; b=WOpLT/zRpKhx5w98Zuydf/uFKe1Ttgyb9zh5RgBxeXoV0ICfQFJ8PlKoeiAkF3wgYLLobZvP9oNJ06mp57qpeK94egWbv9q9BFxjvha8a6IpR9I18PaRpcgWdeYzdjjnjvv3iKAMoGP8Qf4p16PS8D7WZgA88xLPByPbplOXhhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715361952; c=relaxed/simple;
	bh=EsLzXB6Gs7ZQtkmepgwzqKCcyMI9oEm1j34c4xvtcr8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eQzFFATzAIXbuxObi606EZUfESeo4jIL5KAq2CANe8JKpU7EQHGUCzhvio8GXid+AjfVaClupoIZVWDIGGUhMXlmSL9VcNMTFJLdPcEe2DT5a7DE7MR0ImIsPe7K8jOsiLe0Q1otNZ9ADKfvVAidKY2DhtZ0BKnwaAHuj3RhFSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hEpx37XB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hEpx37XB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715361950;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v0uH1Y67e/JYlAU3ZBz+NOGOD31UpxofQKkMvjjtZOo=;
	b=hEpx37XBTAO0dvP8mJEq6vNtmHvRWAEfOT1RbbTrgkBq8QWYgEo/tmWbgdJABmKZhE1yVK
	F1Mg8QmVgXQSpVd4uT7w+ojtIkZdlxgp1G59JusiHdSfzbf+HN28YPUHP5kQLT67QRXs5v
	CRgeKk6VkxukstWaZyTIVZ6+8C9K3f4=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-138-Wj6YN9MLOfSXmRTNVdfzNA-1; Fri, 10 May 2024 13:25:48 -0400
X-MC-Unique: Wj6YN9MLOfSXmRTNVdfzNA-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-51fa975896eso1917384e87.3
        for <linux-crypto@vger.kernel.org>; Fri, 10 May 2024 10:25:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715361947; x=1715966747;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v0uH1Y67e/JYlAU3ZBz+NOGOD31UpxofQKkMvjjtZOo=;
        b=v304azH1/Bhsri2D3GqbhjNmurwAnVaDUKlLj84/QMR0BGPHCLtZCxBKdYxr2aol1E
         KzzHRjd7zheMCbpp1BXICjIDghah9nokTH8SZy1hhhRb6+1taMUSjWBqV+9k6DwY/WFI
         UmCYUU70VZBfH3LhxUMbvv+y7mgJINlvrV1t5ba5y6DR6kR4al+zk5X+tnLkAu+9QzWz
         1CaAEaP/9FrgK/7+27XVeEIDtKwB0CGX/qF7R4u3MjW6C+lpT03RUgYqwGjpHSR1Cf+1
         ZYgAtGNn+4sFDCYkUxCyAlUx7tusCUmXd5SYl4DkI5L+4DBrKAxSI0ewBF8ib6CV8hz6
         CKmg==
X-Forwarded-Encrypted: i=1; AJvYcCUQMMuHq6WGI+vGsGamK6diIpW0/RZvNu27AGu246fau10IpmDA6zM5+A9+6bp5Q1rkbIGzkai2/dvx9pUbLGoL4l0RH3I8XRExRy/a
X-Gm-Message-State: AOJu0Yx7ffDmuJ4OB7yYcc4sLh/twOkopZc4AkSmolTgu6xoTRCFue1z
	53cId+XPJlvgtpcEc0ETWQdpCKYGDLoT8FvNzxfk0DOT1JsVDjnXAiw6yBR6Qa3C1ZEUIPZT8hi
	YZUYgit4sknP4wWyo5A1Kxj8SLhFSrpLZg3H9BX/9QQ74rTt/f5I6mF1TLQjHLFHVafymqldTq/
	fVLJm6Hbo29PZxS3RzO9NaIEzz3UzizgX1//A/
X-Received: by 2002:a19:a40f:0:b0:522:f6:9268 with SMTP id 2adb3069b0e04-5220fc7eed8mr1904825e87.31.1715361947337;
        Fri, 10 May 2024 10:25:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH+3UgqTDnmRVAiNjyATZxMd/ldNZtXGyYEy7zEh+oH8PVqYii06B+EkIez4lJParuMv/x2eUO16iD1lvVu4gU=
X-Received: by 2002:a19:a40f:0:b0:522:f6:9268 with SMTP id 2adb3069b0e04-5220fc7eed8mr1904804e87.31.1715361946880;
 Fri, 10 May 2024 10:25:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240501085210.2213060-1-michael.roth@amd.com>
 <20240510015822.503071-1-michael.roth@amd.com> <20240510015822.503071-2-michael.roth@amd.com>
 <Zj4oFffc7OQivyV-@google.com> <566b57c0-27cd-4591-bded-9a397a1d44d5@redhat.com>
 <20240510163719.pnwdwarsbgmcop3h@amd.com> <a47e7b49-96d2-4e7b-ae39-a3bfe6b0ed83@redhat.com>
In-Reply-To: <a47e7b49-96d2-4e7b-ae39-a3bfe6b0ed83@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 10 May 2024 19:25:34 +0200
Message-ID: <CABgObfaJaDr38BsTYRrMQzYr-wK8cLW+TJr5ewsgBEcm8ghb3g@mail.gmail.com>
Subject: Re: [PATCH v15 22/23] KVM: SEV: Fix return code interpretation for
 RMP nested page faults
To: Michael Roth <michael.roth@amd.com>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, 
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, papaluri@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 10, 2024 at 6:59=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
> Well, the merge window starts next sunday, doesn't it?  If there's an
> -rc8 I agree there's some leeway, but that is not too likely.
>
> >> Once we sort out the loose ends of patches 21-23, you could send
> >> it as a pull request.
> > Ok, as a pull request against kvm/next, or kvm/queue?
>
> Against kvm/next.

Ah no, only kvm/queue has the preparatory hooks - they make no sense
without something that uses them.  kvm/queue is ready now.

Also, please send the pull request "QEMU style", i.e. with patches
as replies.

If there's an -rc8, I'll probably pull it on Thursday morning.

Paolo

