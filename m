Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FAD192D68
	for <linux-crypto@vger.kernel.org>; Mon,  7 Apr 2025 07:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744012416; cv=none; b=nXkb/LQdaRIw8LQSSSPr8gKt2MJ6BiKpbthQO/Xj1eKbGMUp2/+21KU7GLla4TwCIpmFGA9llK919j0D92dJ0ue6g5NwceqmD8VPnxD5wwew6RsweJkTMD+4oNzCVw/jUPfhmIdZl8cYVq+fK3yVSuUmiO1Sp+bEyp2bxJQqvEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744012416; c=relaxed/simple;
	bh=szwnXOzOSOjBOch3SoWaXXjO3Tlak50jw4MvIJHciKg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LKqp4dyFkNPHCQw/RgFp6BkXNhhlwQiI9HzGozjDU36z1+Qa+vAv+f3o0vAuYmiinTYxUyqM4alYUSgLOK9PC7DzRZ4rDjRPcGb/eKuu3NZ3ybwIpYFyLKyaP0qZiNjgJUrVks+1bCklbbwIt5HNNYf1b81QSPIb8S0FyXXk9SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L0NUK7Je; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L0NUK7Je"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744012414;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ofsy77ssOrCPdPnwbpfIBh3i6M18rOr/4yXwZKj56Wg=;
	b=L0NUK7JeD1sQMw4xDSvwNBx9w7BkhnJzcFVg2Cl6vnp9uCjeNaVN9h49J8Sr28z8D/Fj5Y
	aPLp0ugrnkAqmxjJQgj8guIyAddGDXLR/wlg3gVVXRb4lFI/ApCM0lYq9FvAuNwyZeIvFv
	rZrbmNhEo9EMObyQnCFGLzvXnRvP08g=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-275-5ZDHrCzQPVu7eO63b_Fqvg-1; Mon, 07 Apr 2025 03:53:32 -0400
X-MC-Unique: 5ZDHrCzQPVu7eO63b_Fqvg-1
X-Mimecast-MFC-AGG-ID: 5ZDHrCzQPVu7eO63b_Fqvg_1744012411
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3912fe32a30so1585746f8f.1
        for <linux-crypto@vger.kernel.org>; Mon, 07 Apr 2025 00:53:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744012411; x=1744617211;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ofsy77ssOrCPdPnwbpfIBh3i6M18rOr/4yXwZKj56Wg=;
        b=UVZF08R5vAGa+izyp7ywHZSwUUa4Kjtxss+VGntyzYsf+dtziYE45EDQTI3lGy3Igw
         ncBju6gffFX0ZwiIii9HT4LISSO356iIw92KAK9Gc/DRhZt1AogX+IVHCAtikdFwYDii
         LQ6haZkYKyZcHU9OKT7gYR4jB8EjyOkB53AMgj74edbAPB2EMb3vR2QcjQUQTyFY70iE
         Fk8Fu0KRlyggTw8LHkOUmcdVIdayvb0vVeKWki1F43zcRA6YYgKKzcQBovfMJtLcdtZg
         F2uICN+k1ObjVFU2IfYZ/b1dwKCh3W6O6wxPiCK1lkfKdcgxwxG/XhSTbp7j2PkU2+mm
         Yd4g==
X-Forwarded-Encrypted: i=1; AJvYcCX/bfuah3LU00NyzJPxBfiYNHx8kuHmpk/cvzbqMYXXtfs3BaGeB4itm/lC6ssWtp7P+7p42HDDq0duZCc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgCY9xC0vWWriHgWwiD6oedmFHi3m7StjHccYM+Taw8KA1cklB
	U6brRNrcuet1I0aBYni99xZ78w0oj0ugyt02uDxcZVOx4XoygnskMeF5wSwB8DXahVUGMJ548pd
	u6N7FpBcQ4V5+ETPmp1s3kxy0WnA0qM+sVfkOhIqO8Nlbxh5gCyoNeBfISSjHMim+7UCjr2Txvn
	8S85BCzmrGHGwS8vlPaMcvYWxSppspSvkZjqoV
X-Gm-Gg: ASbGncvkXbNqU+knOJqU5XhJIWaMbVt1Hxi7M8pW5tIFVnW41nZ4Wkri7U0Uv2piZ2M
	8RxmD0ADrjdzmXITEZtK+Xkp8jg53NCmeF/FtFYdXBSYA8zFqZ2DdEXQIA3bbSXYCqMdU0Mk=
X-Received: by 2002:a5d:6d8b:0:b0:391:489a:ce12 with SMTP id ffacd0b85a97d-39cba9324c4mr9434693f8f.26.1744012411519;
        Mon, 07 Apr 2025 00:53:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEucAUDP41Wd19TJhxmtFTNd5L+/2tfINDx0SVCwJt1Ss7gnd+Nfa6ty3EOnVN7dms57jS4L4Bva0CX/NdTT8g=
X-Received: by 2002:a5d:6d8b:0:b0:391:489a:ce12 with SMTP id
 ffacd0b85a97d-39cba9324c4mr9434669f8f.26.1744012411222; Mon, 07 Apr 2025
 00:53:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1742850400.git.ashish.kalra@amd.com> <Z_NdKF3PllghT2XC@gondor.apana.org.au>
In-Reply-To: <Z_NdKF3PllghT2XC@gondor.apana.org.au>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 7 Apr 2025 09:53:19 +0200
X-Gm-Features: ATxdqUFovAPd1YyW8urz9uvodd5Msi-Jyl0y3VBXdc00kyPAkug_xTk1qmoKSKs
Message-ID: <CABgObfa=7DMCz99268Lamgn5g5h_sgDqkDoOSUAd5rG+seCe-g@mail.gmail.com>
Subject: Re: [PATCH v7 0/8] Move initializing SEV/SNP functionality to KVM
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, thomas.lendacky@amd.com, john.allen@amd.com, 
	michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com, ardb@kernel.org, 
	kevinloughlin@google.com, Neeraj.Upadhyay@amd.com, aik@amd.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 7, 2025 at 7:06=E2=80=AFAM Herbert Xu <herbert@gondor.apana.org=
.au> wrote:
> > Ashish Kalra (8):
> >   crypto: ccp: Abort doing SEV INIT if SNP INIT fails
> >   crypto: ccp: Move dev_info/err messages for SEV/SNP init and shutdown
> >   crypto: ccp: Ensure implicit SEV/SNP init and shutdown in ioctls
> >   crypto: ccp: Reset TMR size at SNP Shutdown
> >   crypto: ccp: Register SNP panic notifier only if SNP is enabled
> >   crypto: ccp: Add new SEV/SNP platform shutdown API
> >   KVM: SVM: Add support to initialize SEV/SNP functionality in KVM
> >   crypto: ccp: Move SEV/SNP Platform initialization to KVM
> >
> >  arch/x86/kvm/svm/sev.c       |  12 ++
> >  drivers/crypto/ccp/sev-dev.c | 245 +++++++++++++++++++++++++----------
> >  include/linux/psp-sev.h      |   3 +
> >  3 files changed, 194 insertions(+), 66 deletions(-)
> >
> > --
> > 2.34.1
>
> Patches 1-6 applied.  Thanks.

Thanks, go ahead and apply 7-8 as well (or if you don't want to,
please provide a topic branch).

Paolo

