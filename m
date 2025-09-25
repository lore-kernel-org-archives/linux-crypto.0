Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1E425EF97
	for <linux-crypto@vger.kernel.org>; Thu, 25 Sep 2025 08:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758789571; cv=none; b=Wxe9k5nSdta+jA6+GBtt1tM6DPl4SPKVtlBlr6mXRwHWJD8ddjAKCtHm7kcV9s8a8aulzoHiWNnugzITE9N6cEPb3zXBeYGfas+wrBqB6/f564f2kcsIakmEFyuQIHiDrPoE6Aaxd0SHI2CvgwXgM7si32/4Q53nMtKCBFpZVYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758789571; c=relaxed/simple;
	bh=tbpoAV5rkSfpdPr00sFGgdZX3s9IjydPkwrvuz8KxgA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rgzUqdpYva+1O55s4BmfllQs2Eux6bfOIQtdo0w6kZXASv2zFxdUvx90xVsNNV4aV8WDP+EnAp0f08iSCx0l+A132EIEq86NJmZQqq2Nlhtv++eWBqwVv1Wt08LAf5GYOUZYV5kNq9xsrVkji6XPpl24Yzn5x7p2iBMKmao4Ig4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rxuJAMAd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rxuJAMAd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DC7C116B1
	for <linux-crypto@vger.kernel.org>; Thu, 25 Sep 2025 08:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758789571;
	bh=tbpoAV5rkSfpdPr00sFGgdZX3s9IjydPkwrvuz8KxgA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=rxuJAMAdPX5xKmCEQeLmvh1ujK52YyZumQO6MG1UAEbqkSqaSWjjweBbn2OyLGpo2
	 MJS7FtuhexPtBNmK8lrem4E5BdajOzEfeHHH6jLFhOIHgynnITzUNurhUiCi9HEJDB
	 hdfovFUWKAk78xxLKezK8ysV2uhmSeRq2pl/WPbvGeZwEbLel9QmLrjKTIPmbvgHh8
	 x9jNbkOOZhMuHkjOH+jr7uP86wfTt2Szt9tSBujq6cluQNHnrqGSPHxeu6uej+xVHf
	 h8C1ODH1Agw5tLxHXCxWHzgLlUA1uaa3OmLZTmF1QEZlTS8VJB0nQ7w+zn+K9puHPG
	 15V3pbEHn1yLw==
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5818de29d15so901129e87.2
        for <linux-crypto@vger.kernel.org>; Thu, 25 Sep 2025 01:39:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVGGgofmURZwtlL8mmuNPiJ+zDTDB2qF96webkkSMaIWokwXmD6bXH5zz5i6WQlhErl8bI/Ko5Py4VMcjo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZUTOGy/5M7O7uIYr+WHwKUYBw2w5zVWPd9GIhESUozuVc827T
	b0acdtTBqh1o6TTD5ByE9i5NFHEgxR1C/LiIrtbnY97PUG1rgGccH83g4cmhZPjurbVwEk4BK0W
	GCMJJq9KtV1pZ47Jf+UNyf2/oDK0KSJI=
X-Google-Smtp-Source: AGHT+IHLsN2EtNdB2fIFtvSA/U80eTKV8D5qdT2MlBwjOom6gmMCLRDVFq+h1ZbkEBmbg1G/WIiNZD1/OppxbRe+aPw=
X-Received: by 2002:a05:6512:10c8:b0:57c:2474:371f with SMTP id
 2adb3069b0e04-582d32fef36mr768094e87.45.1758789569288; Thu, 25 Sep 2025
 01:39:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250923153228.GA1570@sol> <20250921192757.GB22468@sol>
 <3936580.1758299519@warthog.procyon.org.uk> <506171.1758637355@warthog.procyon.org.uk>
 <529581.1758644752@warthog.procyon.org.uk> <530340.1758645078@warthog.procyon.org.uk>
In-Reply-To: <530340.1758645078@warthog.procyon.org.uk>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 25 Sep 2025 10:39:18 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHzjMBEiKrugxFVn-xGZY2FrKKWbvpp2r9q0E_6Md1KJw@mail.gmail.com>
X-Gm-Features: AS18NWAGIqnzfVXdpFegxk-whah8b8SgJLEJrvUw3GEnyhnyNeOPCp56xNVNAUM
Message-ID: <CAMj1kXHzjMBEiKrugxFVn-xGZY2FrKKWbvpp2r9q0E_6Md1KJw@mail.gmail.com>
Subject: Re: [PATCH v2] lib/crypto: Add SHA3-224, SHA3-256, SHA3-384, SHA-512,
 SHAKE128, SHAKE256
To: David Howells <dhowells@redhat.com>
Cc: Eric Biggers <ebiggers@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, 
	Harald Freudenberger <freude@linux.ibm.com>, Holger Dengler <dengler@linux.ibm.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Stephan Mueller <smueller@chronox.de>, 
	Simo Sorce <simo@redhat.com>, linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org, 
	keyrings@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 23 Sept 2025 at 18:31, David Howells <dhowells@redhat.com> wrote:
>
> David Howells <dhowells@redhat.com> wrote:
>
> > Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > > > I assume that pertains to the comment about inlining in some way.  This
> > > > is as is in sha3_generic.c.  I can move it into the round function if
> > > > you like, but can you tell me what the effect will be?
> > >
> > > The effect will be that the code will align more closely with how the
> > > algorithm is described in the SHA-3 spec and other publications.
> >
> > I meant on the code produced and the stack consumed.  It may align with other
> > code, but if it runs off of the end of the stack then alignment is irrelevant.
>
> See commit 4767b9ad7d762876a5865a06465e13e139a01b6b
>
> "crypto: sha3-generic - deal with oversize stack frames"
>
> For some reason (maybe Ard can comment on it), he left the Iota function out
> of the keccakf_round() function.
>

The Iota function is the only transformation that does not operate
purely on the state array, so that would have required passing an
additional u64 into keccakf_round(). But I agree it is slightly
cleaner, although arguably, it should be a separate change.
