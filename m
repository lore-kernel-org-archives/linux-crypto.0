Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301B1189902;
	Sun,  9 Feb 2025 10:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739096529; cv=none; b=tZSaawHwIbqalbvRCN9YKjmvFY/zJnNTJxBKXFh1LgszdFev7YIRu1z7KSPgQwrZbxDruSW+ZrB54qNBTnGazo+qPzA78HEaWbaElSlw0oOKA8D4rS+35f0tuTyp8Avuq2mDffBAmU5lbkTzSQZ3n3/eUpaHHS0+tYa0vFmCbbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739096529; c=relaxed/simple;
	bh=UPLXXe6L2MrDc++BeOFQIuV2owi8xKA6eaEAAeZ776U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G4YPb0s09RT/giM3z1lnSECA5CoiKrY9pyLYceWMj7qqx4s0tQpOZnhcDE9+6pX2flFQqZYx3VWymxNMOe5CniaLIkcRtBan7IaudppWXt6TCLSNTI3dXM5sGE9J1b2Fe4NrbIqTHAuqPbeO03E6kVwRLlCleWFdR+tpz+hb4H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=MO2maLvL; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="MO2maLvL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mkPPjC8o0FMzZtM8Xt0RmrJn3Y3MticcSZvxgZEKe5I=; b=MO2maLvLsYu1EMaGtfRZxmWxkm
	4Xpbu+Qm9RpGHqbzq+74mtxkXboM7K75TdFmZs0Sszm2rYVzqLT09Yrnx4fLzyYOxMpEKf+GF4mdY
	7oQsF3xxULMwu37xr3pejXwQJBkIuo9IGRJmjgBWG6tO/myjFr5dHfwSj76xrptHjQ7vWTL8AX8Bh
	78gl05Sr5BF+xB/ml1X8+wwWqRJnbs/Uos+g+ABPo+/DOhZZJ916gVuzJ+eA0tR4DlK4yS58+WVuF
	zimwqV3agOSaww1mAW089Boy6Cl7b1B6jX/MkWFcyOTBCpsNjTJdKmN/xGOhM0CyK+TY1I0fVpSTG
	RFXn8CJA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1th4Ei-00GIk9-1g;
	Sun, 09 Feb 2025 18:21:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 09 Feb 2025 18:21:45 +0800
Date: Sun, 9 Feb 2025 18:21:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tanya Agarwal <tanyaagarwal25699@gmail.com>
Cc: haren@us.ibm.com, ddstreet@ieee.org, Markus.Elfring@web.de,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org, anupnewsmail@gmail.com,
	linux-crypto@vger.kernel.org
Subject: Re: [RESEND PATCH V3] lib: 842: Improve error handling in
 sw842_compress()
Message-ID: <Z6iBuarMDVyPv-UA@gondor.apana.org.au>
References: <20250114141203.1421-1-tanyaagarwal25699@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250114141203.1421-1-tanyaagarwal25699@gmail.com>

On Tue, Jan 14, 2025 at 07:42:04PM +0530, Tanya Agarwal wrote:
> From: Tanya Agarwal <tanyaagarwal25699@gmail.com>
> 
> The static code analysis tool "Coverity Scan" pointed the following
> implementation details out for further development considerations:
> CID 1309755: Unused value
> In sw842_compress: A value assigned to a variable is never used. (CWE-563)
> returned_value: Assigning value from add_repeat_template(p, repeat_count)
> to ret here, but that stored value is overwritten before it can be used.
> 
> Conclusion:
> Add error handling for the return value from an add_repeat_template()
> call.
> 
> Fixes: 2da572c959dd ("lib: add software 842 compression/decompression")
> Signed-off-by: Tanya Agarwal <tanyaagarwal25699@gmail.com>
> ---
> V3: update title and reorganize commit description
> V2: add Fixes tag and reword commit description
> 
> Coverity Link:
> https://scan5.scan.coverity.com/#/project-view/63683/10063?selectedIssue=1309755
> 
>  lib/842/842_compress.c | 2 ++
>  1 file changed, 2 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
