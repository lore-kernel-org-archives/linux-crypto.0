Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF14D3A783E;
	Thu, 26 Feb 2026 18:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772130820; cv=none; b=hRV46n1Po2Kkl86ndAaEdSdvue1du2eEMaOn+dUl8O2nyrmi1mgZbgUme5u4UHgXeoyfAywa/DtOw7Q3ttRRw8TCuBRSJv3DZ3lPGVd9EMRFLhoypg4LbD8ws1IuDXvKvzA+7QzFSXA3SWKECuSPF4rZ/bnPo8xjuuCXaV04dMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772130820; c=relaxed/simple;
	bh=U/Z/ceAeahWvC5StdVOl3pvQlYfwBIFDv5N/bOtobZc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r2pMJfcnYQC9rpp2ZqG3Xc5EwzTl8dce8ksDJwiy9ePZuRXz3uWyeXZCzuSCb0kOTUlhieXWh9Jdk0pu4kiuPNahdxQ4Ncl8tOwadghaTJFOExV2e/DSw09vXJaxRX9y9xn2eJgH9GKPvJptXr9ESwNcyXivx1PUZrajKijiHJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FTAQLlRx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FTAQLlRx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF94AC19423;
	Thu, 26 Feb 2026 18:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772130820;
	bh=U/Z/ceAeahWvC5StdVOl3pvQlYfwBIFDv5N/bOtobZc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FTAQLlRxPUjjgPbzWiRTzE2gQd92DDGXxIkXnAyRFzc1l43gafZ00xivzEexR4TCi
	 YNPdDJO96XhcA2oiS2qhiR258bmNMPE2Cv+EGOb4esvJ3tYl2INV8t9S+IjjJj2pKK
	 6uVClLDkjGMGRUNzdTKJuBTcbOVeqs2mfXo6yemyuUCEaououaMsYthJHvU/2m32pk
	 tr55IbvLZMmExU8QcyToUVqn19iVOfSj0KxlK2c1BulINQopqaZxKymx3TzJPRDQKb
	 5H7qgynGr+plJit0uMRLAdRw5uXP5smUYokuUfxHT0KAIrV3Wj1+mjB1v4/257CYOI
	 24SqxqBnoD0SQ==
Date: Thu, 26 Feb 2026 10:32:48 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Stefan Berger <stefanb@linux.ibm.com>
Cc: Simo Sorce <simo@redhat.com>, Coiby Xu <coxu@redhat.com>,
	Johannes =?iso-8859-1?Q?Wiesb=F6ck?= <johannes.wiesboeck@aisec.fraunhofer.de>,
	dhowells@redhat.com, dmitry.kasatkin@gmail.com,
	eric.snowberg@oracle.com, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
	roberto.sassu@huawei.com, zohar@linux.ibm.com,
	michael.weiss@aisec.fraunhofer.de
Subject: Re: IMA and PQC
Message-ID: <20260226183248.GE2251@sol>
References: <aXrKaTem9nnWNuGV@Rk>
 <20260130203126.662082-1-johannes.wiesboeck@aisec.fraunhofer.de>
 <aYHznG6vbptVOjHQ@Rk>
 <ee36981d-d658-4296-9acb-874c72606b3e@linux.ibm.com>
 <20260226001049.GA3135@quark>
 <cba10ac6-3557-4fc1-9b86-55361d14156d@linux.ibm.com>
 <dc09be79-5efe-4756-a295-5b0428985525@linux.ibm.com>
 <da190dbbc692b9da8464bbbfffdde7bab26b3f1c.camel@redhat.com>
 <20260226165819.GA2251@sol>
 <969c74f3-81ed-442c-87dd-381274a642a7@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <969c74f3-81ed-442c-87dd-381274a642a7@linux.ibm.com>

On Thu, Feb 26, 2026 at 12:22:32PM -0500, Stefan Berger wrote:
> > I see that IMA indeed never upgraded full file hashes to use
> > 'struct ima_file_id'.  Building a new feature that relies on this seems
> > like a bad idea though, given that it's a security bug that makes the> IMA
> protocol cryptographically ambiguous.  I.e., it means that in IMA,
> > when the contents of some file are signed, that signature is sometimes
> > also valid for some other file contents which the signer didn't intend.
> 
> You mean IMA should not sign the digest in the ima_file_id structure but
> hash the ima_file_id structure in which this file digest is written into
> (that we currently sign) and sign/verify this digest? And we would do this
> to avoid two different files (with presumably different content) from having
> the same hashes leading to the same signature? Which hashes (besides the
> non-recommended ones) are so weak now that you must not merely sign a file's
> hash?
> 
> The problem with this is that older kernels (without patching) won't be able
> to handle newer signatures.

IMA needs to sign the entire ima_file_id structure, which is indeed what
IMA already does when it uses that structure.  (Well, actually it signs
a hash of the struct, but that's best thought of an implementation
detail of legacy signature algorithms that can only sign hashes.  For a
modern algorithm the whole struct should be passed instead.)  Just IMA
uses that structure only for fsverity hashes, which is a bug that makes
the IMA protocol ambiguous.  It needs to use ima_file_id consistently,
otherwise a signed message sometimes corresponds to multiple unique file
contents even without a break in the cryptographic hash function.

Sure, when that bug is fixed, old kernels won't support the new
signatures for files that use a full-file hash.  But the same applies to
starting to use a new signature algorithm, such as ML-DSA.

- Eric
