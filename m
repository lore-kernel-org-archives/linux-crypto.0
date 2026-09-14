Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F315B3E9C36
	for <linux-crypto@vger.kernel.org>; Mon, 14 Sep 2026 10:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789381005; cv=none; b=Xqno5KEBAvhHFANfPwC7ixaZF1yFh+eOW6ce2uE2pasXnxPuSe/80mFUp37Az0o+LYGmnZHIWhqWvqEl65iTxCHNnknDWdkoMbTCFjbZ49zVeiSm7gwAbu0IWATkbn0csqb/IilwpJz85qANtvqX0PEYhUjN7EUxa01YmxEF3bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789381005; c=relaxed/simple;
	bh=fcGBWMzXwGeD490cfOtwdYySPsaVb1rd+Nu6Msaef0U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PalsKUt1y6g0E+n4RiH0jdVsFck9M5JPFk+nx2DId4ZFJ0bFnrS+AkBltApQZzKBKUZb72Ldhj1pXLqGAzbHgxm0Vn1fjJyewVHlyiQwAcJkKMOVEt0bTj8byyL7tQb3JxIXl91ENZtWq2kIMxmwgKFm5Rc6jf29CD/nUwmY8gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 70E8C6032B; Mon, 14 Sep 2026 12:16:38 +0200 (CEST)
Date: Mon, 14 Sep 2026 12:16:32 +0200
From: Florian Westphal <fw@strlen.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: kadlec@netfilter.org, linux-crypto@vger.kernel.org
Subject: Re: [v5 PATCH] rhashtable: Add rhashtable_flush_and_free helper
Message-ID: <aqfJgFY73ZYtFJmH@strlen.de>
References: <aqUmlWEzhR3pKYuP@gondor.apana.org.au>
 <aqWazNYddvTO5Sjn@strlen.de>
 <aqXf46iXp4BhuPud@gondor.apana.org.au>
 <aqXqftkCP3Jv1CXK@gondor.apana.org.au>
 <aqX9l6vIJdzBSiUE@gondor.apana.org.au>
 <aqYQJlrjbxEgp4Y4@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqYQJlrjbxEgp4Y4@gondor.apana.org.au>

Herbert Xu <herbert@gondor.apana.org.au> wrote:
> v5 makes the following changes:
> 
> - Add bucket_table dying flag to fix walker race.

Thanks, I rebased the ipset rhashtable conversion patches
on top of this; all tests pass.

> Once rehashes are completely gone, ht->nelems is reset to zero,
> and the new table is installed.

Wrt. to this, you could do:

diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 63129a8e223b..c5a3c15b3f7e 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -1265,6 +1265,8 @@ static void rhashtable_free_one(struct rhashtable *ht, struct rhash_head *obj,
 {
        struct rhlist_head *list;

+       atomic_dec(&ht->nelems);
+
        if (!ht->rhlist) {
                free_fn(rht_obj(ht, obj), arg);
                return;


To avoid the need for an 'atomic_set'.  That said, I don't mind the
NULL-plus-concurrent-insertions-drop behaviour, its not an issue for
ipset.
