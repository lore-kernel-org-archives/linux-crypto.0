Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B92C1FECD2
	for <linux-crypto@vger.kernel.org>; Tue, 17 Dec 2024 16:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734451221; cv=none; b=ELeHFVKVcbP7/EzSGXIbLTOzwFnolJHLw4eyIKdD2vlR6lIOJ8XDfPgC2pC8uPyM9+0GHA350krYOZrBfIOVgDVf3S5kA7x+p5ycrBM+RSqshEqTLNuFtFtdBhIMKMYpXoajUJ63FNeWoGMJ+Bb2ywZQKjiz6w57dM3yMEn0Y0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734451221; c=relaxed/simple;
	bh=yMkXhimHSNgkCBtW6GdCu0qlZ/ulIAiC5pNf9JbKmis=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IMiwiXAaiO/ws7Q2Zi40MCrvPem4rwhbIUshzE+tnoCc6XhOw7mywmxZsAv6X5Ru3wHiPm9WBCvpjbBzuPjwQWytAq3uGYnKyykoYP77gX3ITD+aL/aLjupDzT6r+V9OpeKId4bmnffn75PXLtFfQoc/ZYOolr4/+u9kOS8vNbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FRZleV7S; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FRZleV7S"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5d3d479b1e6so6931565a12.2
        for <linux-crypto@vger.kernel.org>; Tue, 17 Dec 2024 08:00:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734451218; x=1735056018; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yMkXhimHSNgkCBtW6GdCu0qlZ/ulIAiC5pNf9JbKmis=;
        b=FRZleV7S6N3uH8R+za9DNTKgPyMOScy6hJa1YLIVyflfthbswn65RvKJbCX7CLE0Cy
         Yy46jrOP3RVTLHCoBof0LJ1aAc+O5WX8xSndxJqKP/fBkF5yJeBMZSPSsRvY9bbgDLQS
         Xu5hTwIOU7dwlEU3Phn8MRVJCOohNC4/OrWy1WFMLNxHGDR2hSknzvr6CMRd+kO9FQSB
         Mw4sAcmZ9DKckUJBkJVLgkkR+ojddp8eh2cgntxE5z91TmF+MqqbXj5QyipXtK4afWbu
         s1o+Qanq+de/wkzRfZD8Uk6geWArpdyTkUx/7PTaogmD9d4y1zuiLuwE88SCgM6ri9WV
         NlTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734451218; x=1735056018;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yMkXhimHSNgkCBtW6GdCu0qlZ/ulIAiC5pNf9JbKmis=;
        b=HkzZ2eCTYL+ytMeWkICfdMCBxPNFdmToKJ858B9RXHK7hz5YQV5+HQTew8+kaqBa/S
         8XmyrHPC4bElNpFcg4PtS0O4ALAPHlf16qEJxyTBO5NOBLdkVruOv4ogxtq5pXWc0DSD
         cfaJBvoRTdhM/X3BhYH7oIZTRuss/P+vH6wPiNdDak/n9nDXOfqSCAzzchBdplUZjCOY
         +PqHm3pS/LP2WXiqPgEh4pts+JIxJHkFMYxAvs/7pxdmPp4acGsArOliJAHw58vd+V3a
         qQ+oPN19ARFyVarJP0c2LzCP9XIym8wk4FBrx8AxaUqrhB/F+8qOy1fWt76iK7UPr0Mg
         lrIg==
X-Forwarded-Encrypted: i=1; AJvYcCWWNQDx2977Z9+aUssWj5/PAxomIp/iMTeht1vhv4+n8JgGP8hA3jCmyi9jpd97GuQTAmANgO4a+KTZTU8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhfwIu6t73GGZQ6tl4q8WekJBNqKQAVnNB5VR1nvHrCaFa/Pfz
	JhBlz3u1k4CvL5b1Q53D551GS9GBHvjoAQCYzRIJ8EP5VUXwlyXqWvTfP2Kzvi/OyJxQXlpyEz1
	JfS6VNRoiEIJ0A12N9gxZP+KRXa0Twaxq0b7y
X-Gm-Gg: ASbGncukD/APfy/Nu9t0Nxe/HZuHqIY1sjQtAmFe4wVZICcF9q9ruxlSlSCJtNuHSCG
	aDUX7VwUD14AlRPBfV+StaqdX46e7aludqb6Gdw==
X-Google-Smtp-Source: AGHT+IFNZC7Hw++tMkFStafWWMV/GkZvsv2xsoec16XXjJA34YsckivhWJKovnlU3n2/vwLA3YFKSwnXRytZtX+iWQc=
X-Received: by 2002:a05:6402:5415:b0:5d0:bf5e:eb8 with SMTP id
 4fb4d7f45d1cf-5d63c3dbc28mr38182350a12.23.1734451217876; Tue, 17 Dec 2024
 08:00:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1734392473.git.ashish.kalra@amd.com>
In-Reply-To: <cover.1734392473.git.ashish.kalra@amd.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Tue, 17 Dec 2024 08:00:06 -0800
X-Gm-Features: AbW1kvYYZJqPhmb3aGCl1ViLv-OIblMbuwwguLZErK06_FPk8Pypubp8GuwTI4k
Message-ID: <CAAH4kHa2msL_gvk12h_qv9h2M43hVKQQaaYeEXV14=R3VtqsPg@mail.gmail.com>
Subject: Re: [PATCH v2 0/9] Move initializing SEV/SNP functionality to KVM
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, thomas.lendacky@amd.com, john.allen@amd.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, michael.roth@amd.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 16, 2024 at 3:57=E2=80=AFPM Ashish Kalra <Ashish.Kalra@amd.com>=
 wrote:
>
> From: Ashish Kalra <ashish.kalra@amd.com>

> The on-demand SEV initialization support requires a fix in QEMU to
> remove check for SEV initialization to be done prior to launching
> SEV/SEV-ES VMs.
> NOTE: With the above fix for QEMU, older QEMU versions will be broken
> with respect to launching SEV/SEV-ES VMs with the newer kernel/KVM as
> older QEMU versions require SEV initialization to be done before
> launching SEV/SEV-ES VMs.
>

I don't think this is okay. I think you need to introduce a KVM
capability to switch over to the new way of initializing SEV VMs and
deprecate the old way so it doesn't need to be supported for any new
additions to the interface.


--=20
-Dionna Glaze, PhD, CISSP, CCSP (she/her)
