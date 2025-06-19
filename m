Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D59223311
	for <linux-crypto@vger.kernel.org>; Thu, 19 Jun 2025 10:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750328848; cv=none; b=ZG5pMR+dkiNQV+0szGAj7kP3SXzJ9ZXXTwid1X4K0zWZVnm1QnoyGkfsVKzquWGw+lG9xg2R72VPnTSvMEWypjm9P9qi5rtYYDe4I/jj5PXO+8PTXPO8F3vODqsHi6Al+tYU7Nrsmwv0SIqd+LcJ3eM/0kQi6kgc1OTNHpJqnEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750328848; c=relaxed/simple;
	bh=Ha5pBnLB+/Wbwr2eoWpkZtiP3585DllDK64zqWFbpak=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oh1pyZaAYsctTcmhF6vIhBYD/Uo61w7c409bDsSN35wjSkSCWF50GIUZtztVFUCjF/xTRp+d4u7e6EpPB+ND1nTNrgchQaXCwjQ3StPf+2bzZnOAJNGZpVFwFandTbWYi3+7NGv99U4lf0avVuSrPZZdK+e4N7CWmYRAL8t661w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JqML1Wc7; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JqML1Wc7"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-60789b450ceso1128366a12.2
        for <linux-crypto@vger.kernel.org>; Thu, 19 Jun 2025 03:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1750328845; x=1750933645; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rZdjOXoFyem5NArONK8WTWDxOqEiaiq3A+0Wr1BizhY=;
        b=JqML1Wc7NAPWv3jL7VLHB1MZbHZO0/r1ugdc5f4weQlFrr1GcdTqHydNmE1MRa5/kF
         ufOTkR6Ig3UNdJpMBWSqTtwOgRx4lbho2ahCK3FlZ+C/wPRXwOSOmpB0r25t784+HrEy
         x/SVy/S8+1DCYV1HsHi7k/G6cEsirZgKD43YVS3AlN5OI3wIsvgX6F1XPX7jZtuIAnF8
         se2axncjg8I/2lDU74Ut+MARSWJenNq+UyJBid+NkgVdEWSBmnjO+rXWIaizPTOGG7Yq
         cL/NBlzsaURJZ4qEyE2PDh8jMPNd5fgfj8c/Xubce2jbOjIdmt3hMD0wYGpGqeYn/3av
         eIjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750328845; x=1750933645;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rZdjOXoFyem5NArONK8WTWDxOqEiaiq3A+0Wr1BizhY=;
        b=Yl+kPHPkePMhM5dFfZrtAx0rpUmrJo9PUgtDtGhHygbUiBPMdutMWbY3MxPvgoCROG
         R9M6c+IDaiKTOFmPrOF9b2bUZxOm56OlCktgw9v94E7dWWKOJZTyb3IjZNWwXC/OKdb5
         YUOn1/YmgImixdfjJHR8RaAAB1lf6O9L6u3xhZ6p/VJEj3/kmexXMUuW282REL59AZvY
         VOYLDXjIrGndc3z29zLmQmO+3XY0gNjlxSMv1tf+xHvQ167+ofY8IZSPw3UN3Ym89yyF
         l0qh+SCv2GygL6SpocCiWT3fqog9kle+rsxhlZqbFIGC5DfaNgL2ZJiiLoSXlYZOGWT3
         Atcg==
X-Forwarded-Encrypted: i=1; AJvYcCU0WlQ/Z7xnRwZ/BmhaI6WrigIgfOg5/NIh6Q3kVV2XB9qHsT8C62H2Yjz03umK0rF3wcJth7g60Ph8Mac=@vger.kernel.org
X-Gm-Message-State: AOJu0YwN10DHoCVIbXrvAqnpNNAw1bXyNqXsB+l9IVvzPZuSuStftnqo
	PyDfUNfOpUApdw/kRyrGIxUUitkeNf6+ljsblCWtZbWRoi242+XDBi6RLNU4QTQ+BCPhpEhOL74
	ZqQR6jzwnXlWMNR0nG20ubYNE0i+NDDV7W6N67KhOoz6F3KzQdC63
X-Gm-Gg: ASbGncuiUqsqbCxB9rHxeBQljCQ0LyNItJJqO5z7CxDG8BCQ6XQOI0OZdxcS5x9eO2h
	XCZQrLXWVsl/yb/qJyQ5eETGk0XywNZfSIC626VK08f5rffIt9scHmzHmUKWaHgy16X6hug72r6
	t/ffnEIa9Ey1eTCR3rlc9wdqYqmB7vPkH03f4cYn0/GA==
X-Google-Smtp-Source: AGHT+IFYv31V1VgYj7wiOVm2AcC04l9vXTzMKPEBeuLWE5AE7D0FfXX1iQiGE7VRTJ93WYdkcN9OxbbTEzQSKRnBhmU=
X-Received: by 2002:a17:907:3d45:b0:ad8:91e4:a937 with SMTP id
 a640c23a62f3a-adfad6d19a6mr2027896366b.57.1750328844882; Thu, 19 Jun 2025
 03:27:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250613183753.31864-1-ebiggers@kernel.org> <20250613183753.31864-3-ebiggers@kernel.org>
 <20250617201748.GE4037@suse.cz> <20250617202050.GB1288@sol> <20250617204756.GD1288@sol>
In-Reply-To: <20250617204756.GD1288@sol>
From: Daniel Vacek <neelx@suse.com>
Date: Thu, 19 Jun 2025 12:27:13 +0200
X-Gm-Features: Ac12FXxSj7KHDxvaD5P250FA9B_gw9jTRxjEbr9hoYukN-7E6ZC33jFtxLAiusA
Message-ID: <CAPjX3Ff-A+M9Ad7iJFTDGAs=M1d6zOqDq48i1GmRn967a_GDsw@mail.gmail.com>
Subject: Re: [PATCH 2/2] crypto/crc32[c]: register only "-lib" drivers
To: Eric Biggers <ebiggers@kernel.org>
Cc: David Sterba <dsterba@suse.cz>, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, linux-btrfs@vger.kernel.org, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, 
	David Sterba <dsterba@suse.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 17 Jun 2025 at 22:48, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Tue, Jun 17, 2025 at 01:20:50PM -0700, Eric Biggers wrote:
> > On Tue, Jun 17, 2025 at 10:17:48PM +0200, David Sterba wrote:
> > > On Fri, Jun 13, 2025 at 11:37:53AM -0700, Eric Biggers wrote:
> > > > From: Eric Biggers <ebiggers@google.com>
> > > >
> > > > For the "crc32" and "crc32c" shash algorithms, instead of registering
> > > > "*-generic" drivers as well as conditionally registering "*-$(ARCH)"
> > > > drivers, instead just register "*-lib" drivers.  These just use the
> > > > regular library functions crc32_le() and crc32c(), so they just do the
> > > > right thing and are fully accelerated when supported by the CPU.
> > > >
> > > > This eliminates the need for the CRC library to export crc32_le_base()
> > > > and crc32c_base().  Separate patches make those static functions.
> > > >
> > > > Since this patch removes the "crc32-generic" and "crc32c-generic" driver
> > > > names which crypto/testmgr.c expects to exist, update crypto/testmgr.c
> > > > accordingly.  This does mean that crypto/testmgr.c will no longer
> > > > fuzz-test the "generic" implementation against the "arch" implementation
> > > > for crc32 and crc32c, but this was redundant with crc_kunit anyway.
> > > >
> > > > Besides the above, and btrfs_init_csum_hash() which the previous patch
> > > > fixed, no code appears to have been relying on the "crc32-generic" or
> > > > "crc32c-generic" driver names specifically.
> > > >
> > > > btrfs does export the checksum driver name in
> > > > /sys/fs/btrfs/$uuid/checksum.  This patch makes that file contain
> > > > "crc32c-lib" instead of "crc32c-generic" or "crc32c-$(ARCH)".  This
> > > > should be fine, since in practice the purpose of this file seems to have
> > > > been just to allow users to manually check whether they needed to enable
> > > > the optimized CRC32C code.  This was needed only because of the bug in
> > > > old kernels where the optimized CRC32C code defaulted to off and even
> > > > needed to be explicitly added to the ramdisk to be used.  Now that it
> > > > just works in Linux 6.14 and later, there's no need for users to take
> > > > any action and this file is basically obsolete.
> > >
> > > Well, not the whole file, because it says which checksumming algo is
> > > used for the filesystem, but the implementation part is.
> >
> > Oh, right.  It's one of those sysfs files that don't follow the normal sysfs
> > convention and contain multiple values.  I'll update the paragraph above to
> > clarify that it's referring to the driver name part of the file.
>
> I revised it to:
>
> btrfs does export the checksum name and checksum driver name in
> /sys/fs/btrfs/$uuid/checksum.  This commit makes the driver name portion
> of that file contain "crc32c-lib" instead of "crc32c-generic" or
> "crc32c-$(ARCH)".  This should be fine, since in practice the purpose of
> the driver name portion of this file seems to have been just to allow
> users to manually check whether they needed to enable the optimized
> CRC32C code.  This was needed only because of the bug in old kernels
> where the optimized CRC32C code defaulted to off and even needed to be
> explicitly added to the ramdisk to be used.  Now that it just works in
> Linux 6.14 and later, there's no need for users to take any action and
> the driver name portion of this is basically obsolete.  (Also, note that
> the crc32c driver name already changed in 6.14.)

How about instead removing that part since it's useless now?
