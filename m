Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0123F787E;
	Thu,  8 Oct 2026 09:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791452303; cv=none; b=TsD8TMGXfCj7uS8v54d+U0ayQkabuTYfIWvxV84xsNL8qBMJz3JJLVUqCRXhbAt25E+nbKZeRggUZs7HyUEzPBa++9v2r66T9H/j8QE8r5N2YSWESdqQTgJ6DCSeQegK6ZCdgYXaFlWrdrHtr8hCZUIddjISQ8UiYHHoAyAre0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791452303; c=relaxed/simple;
	bh=nnscKn1wEp/rtypGzD2BDiO0qA6U94JjEgTxpNHQ01s=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=apPuZHrHLGFYR3A2If8Tj9lcmPq+HN0MZEK+HgdRtyaTzWiTiczR7uOE7ciX5dUmbsaNV9SnNILRbyo46SHI4huU162MfO6n3WoyCCC0+ffjtomfkm4o19cgUNR0dLLkjcgrYOFejIATT0eeuRmXeYU1q/b5xhmyJGVj8XJ+Mik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=UzzVxIaf; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="UzzVxIaf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:
	Reply-To:Sender:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=6y9keDCpNEXGfcE8lb9J8bKLESkB7T/8lsxsJ3Xb15Y=; b=UzzVxIafzqyagIYaOqTlAL4cJf
	lwKotMiXPyAJENllgMYS5LlSuo+N57anN6zhd1Ldfpw314mk2oWYAA1uwUsfW9QffPVfmW7lC/TJm
	n8GgK1auql/A74IyDpwV+NKz13VISgg4iwB7KIU6j1QkKWYFEz7D2oRj+vQ0K+GD8868cMrFPLN5U
	0MSmfF0DIwQEWp0UFyhyagm4LAn/d7D/FpeIjbKsrz7Qa8IO47QbF5T7YRxpguw8NfoVRBW+3TGys
	RWa/evFWk8clzDs/eoqaBQwrqWTafRU1IxSq49uk25ZSHh0hSBnJwzAbMb14WUOL1Zc/mCmg5AJSp
	a1Fvu9XQ==;
Received: from [::1] (port=58644 helo=pf-012.whm.fr-par.scw.cloud)
	by pf-012.whm.fr-par.scw.cloud with esmtpa (Exim 4.100.1)
	(envelope-from <jeremy.jean@oss.cyber.gouv.fr>)
	id 1xEkZu-00000003F08-3kWD;
	Thu, 08 Oct 2026 11:38:18 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 08 Oct 2026 11:38:18 +0200
From: =?UTF-8?Q?J=C3=A9r=C3=A9my_Jean?= <jeremy.jean@oss.cyber.gouv.fr>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: horia.geanta@nxp.com, pankaj.gupta@nxp.com, gaurav.jain@nxp.com,
 davem@davemloft.net, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: caam - reject overlong RSA CRT parameters
In-Reply-To: <asdWCJgRzQuH1wH0@gondor.apana.org.au>
References: <20260810154024.3178145-1-Jeremy.Jean@oss.cyber.gouv.fr>
 <ao4xobfWhs5Ss8Uy@gondor.apana.org.au>
 <752d9ff313bb52a7f8d2295161c1d9a4@oss.cyber.gouv.fr>
 <asdWCJgRzQuH1wH0@gondor.apana.org.au>
User-Agent: Roundcube Webmail/1.6.19
Message-ID: <f3b5863bad3f025f3ddf859397acddc8@oss.cyber.gouv.fr>
X-Sender: jeremy.jean@oss.cyber.gouv.fr
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

On 2026-10-08 10:36, Herbert Xu wrote:
> On Sat, Oct 03, 2026 at 11:21:44PM +0200, Jérémy Jean wrote:
>> 
>> I don't know for sure, but it is still getting fixed, e.g.,
>> https://lore.kernel.org/all/FF2F0DC4D3930E6A+20260923101457.204629-1-zhaojinming@uniontech.com/
> 
> Can you please repost with a Cc to the new maintainer?
> 
> Thanks,

Hopefully done.

Thanks,
Jérémy
