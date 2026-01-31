Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C1A3EBF04;
	Sat, 31 Jan 2026 06:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769841199; cv=none; b=RJqApaTkQlWGa9TeKZ3SV2AkQVFR4y68gZT8a7pz86ALIHBKiyzXbp00EfwsRyHdtGBF+jXstPDg3FrTUC9hs3GlLSLZCuxILQ83v1dqiSc7Zbu6w7G1n6bGY+tZZsrb2VRw+iHtHj0F6eOVBoDNIPGhF65POrcD0gzkfd1sG0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769841199; c=relaxed/simple;
	bh=9vrv01aR9Ykr9A0LloF+sgcTyLfDpmc0JEwafBOKjlc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NQhVewiYzrubPeFwyQmQaVzNFtw4+N50iSnrA0uHeeChHECKyzNrLGmEBSpdmABsVADNwBJlHL5ulBXBfJtBCZSYHGkBu81eBKatZPl9M1YB8iiG4wTzMz8pzOzbkTtjPqkxPJpXY83v3ba3FSFdM8np9D4evKkpNYaRH9lbF6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com; spf=pass smtp.mailfrom=perches.com; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=perches.com
Received: from omf15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 82BF91A0720;
	Sat, 31 Jan 2026 06:33:16 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf15.hostedemail.com (Postfix) with ESMTPA id 366D81A;
	Sat, 31 Jan 2026 06:33:12 +0000 (UTC)
Message-ID: <47e684fa24ef3fc209c7045579c43405a9183427.camel@perches.com>
Subject: Re: [PATCH v2] crypto: ccp - Fix a crash due to incorrect cleanup
 usage of kfree
From: Joe Perches <joe@perches.com>
To: Ella Ma <alansnape3058@gmail.com>, thomas.lendacky@amd.com, 
	john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net, 
	arnd@arndb.de
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	julia.lawall@inria.fr, Markus.Elfring@web.de, Tom Lendacky	
 <thomas.lendacky@gmail.com>, Matthew Brost <matthew.brost@intel.com>,
 Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>
Date: Fri, 30 Jan 2026 22:33:11 -0800
In-Reply-To: <20260109151724.58799-1-alansnape3058@gmail.com>
References: <20260108152906.56497-1-alansnape3058@gmail.com>
	 <20260109151724.58799-1-alansnape3058@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 366D81A
X-Stat-Signature: merz66146yn6iaubwzxwpkaxg8pkt9z3
X-Rspamd-Server: rspamout08
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18FD5waYhn8UpOMoJcGjVMukjlZ9XIjSZM=
X-HE-Tag: 1769841192-310565
X-HE-Meta: U2FsdGVkX1+bwkH9/wRh6uJK86+YzMyiwDAuCMWWY+xWZvlQoeBzt+rVan3h5+YVpOmzSfZrYsv6OTLs76zdny1WfAjn4axb5eSiKz7DM4TCJwkEVx1vrFQE4RYe17Z8Jqo6ILPOPf99kZpROG47Vi8HAY8pR40XkbUeVhkQlUfVCk9QE7HteuDrBUSIAahjj95Rsif5oemi8McGz9xRL1s3SHu7amUKkZOKVpITxLTQCcDVzJTuurVbsMSXxZ8QzJvnuKyP8yeDd79TH+rF9T2cm5WdF6Wbvwg4rKcs2zy4SkUp3YOR0GbicoqifUmm

On Fri, 2026-01-09 at 16:17 +0100, Ella Ma wrote:
> Annotating a local pointer variable, which will be assigned with the
> kmalloc-family functions, with the `__cleanup(kfree)` attribute will
> make the address of the local variable, rather than the address returned
> by kmalloc, passed to kfree directly and lead to a crash due to invalid
> deallocation of stack address. According to other places in the repo,
> the correct usage should be `__free(kfree)`. The code coincidentally
> compiled because the parameter type `void *` of kfree is compatible with
> the desired type `struct { ... } **`.
>=20
> Fixes: a71475582ada ("crypto: ccp - reduce stack usage in ccp_run_aes_gcm=
_cmd")

Perhaps this one too?

drivers/gpu/drm/xe/xe_guc_ct.c: char *buf __cleanup(kfree) =3D kmalloc(SZ_4=
K, GFP_NOWAIT);
