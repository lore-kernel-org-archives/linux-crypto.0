Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DEEF1BFDF7;
	Thu, 10 Oct 2024 09:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728551451; cv=none; b=BcgeO29ktZswRrLTa2ZXQkLD9bnwdhtCo91RbPNDZuWeZTBFiTud6SuLhAwOvDvRmg39PaMgFVtRJ5GBA+migxXsCGb8isT/xFys3Bs6Alg/pMbIvXtAVS5Oa0+dAxVqtCneaPYc2RcPz7fx/FEk2CyzNvlWwIVgKTfbcfb5Ifw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728551451; c=relaxed/simple;
	bh=07x78Sg1amxalMRiVKpv9RyTwRr1zMKzZxbI/cyJf18=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L0b1ZfaUD7yY9YJqkkIJnD1RSm254wenuMwXrfyZinqsKFfCwZO1QHsqEb+P5HRYDEcqoUO17YR111iFYTOZZkE6HTst2909eGeNTMvbIrV8ZDow8oEFt5kuYbuUmjw2LXYxIEbMSb817FxxZCidqrTIrn0+yziOREVjoHgG0bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=IJupk2Kg; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="IJupk2Kg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1728551432; x=1729156232; i=markus.elfring@web.de;
	bh=07x78Sg1amxalMRiVKpv9RyTwRr1zMKzZxbI/cyJf18=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=IJupk2KgLk98gJ0eIxIQ4gk89gymoyZ2JK40dq8FePmNOAKAG1ZWNoy+KB4F2b2A
	 XwquA/zJfIEbId4EWdgP+GmL424jT/n27cN9XxhD9lU/iSlJv8xA+Mf/fy8oiJjw4
	 fySkqrBYgvtD+kq16mwj2+htT2nm6YFAtyLlH6djYzbwtiiCLV533zQ0uNBbqaieX
	 dtoVNYjOnpZVbSfln4bnit1CaoWKSkgjvtqyUvUoAN+WYkzC6KTpIf4/00s1421FO
	 cnqhfX3cNVHosG04ZTUUbTmA7x9GCBM5on0wo4pGlBUodDPe30iWfnmvwZ2vOtVos
	 SzBjyOl9nCcyj0kHug==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.81.95]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MxYbD-1tvqxl0F6f-00xKlj; Thu, 10
 Oct 2024 11:10:32 +0200
Message-ID: <1df1df73-e741-4ebe-9514-8466b4b276e8@web.de>
Date: Thu, 10 Oct 2024 11:10:30 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v2] crypto: lib/mpi - Extend support for scope-based resource
 management
To: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
 kernel-janitors@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel test robot <lkp@intel.com>,
 oe-kbuild-all@lists.linux.dev
References: <bc5ce9ad-acbd-4f3b-91d6-10cf62bf5afc@web.de>
 <202409180725.ZV8DCvII-lkp@intel.com>
 <91d10516-4ba9-4fe0-8f63-86205cc4f88c@web.de>
 <ZwDPp4bU1J5uEgQe@gondor.apana.org.au>
 <9ddc71e7-e98a-4fa8-b140-4035dd2874b6@web.de>
 <ZweTCO8cFtP_pvOu@gondor.apana.org.au>
 <4aef34ca-4665-4e92-8ce8-8a8a2fb472c9@web.de>
 <ZweXlC7G8rEK9rB7@gondor.apana.org.au>
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <ZweXlC7G8rEK9rB7@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:95Ta7s8qYi4mGs53r1PV8Gfa3Lxp61fGKOWaCTgnyTxoqll4vBd
 6cjxlpuXklwiOXmqZy9hH2CWR+n6WRUah5IDnKiGhaFV6Nvd93qQOJAtmTRISs7Y3ChlLu2
 WETHu12d+aITHuLbkPvm3lKzPfIQLgC5S32EkFVCFA7L2T89J3OV9Sp+qnNC6GQjY6NPx2B
 +nT8hoc1j1tnwHbfDsEJw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:2NCzZm+tM24=;hohcUvjS/CGjznp4tKpsRsApGQJ
 vrXNV7XHyseqJE6wk1hBB8yzUQXHmE5xAzaGLDW5Zk9TNleQbOrb7FiU1+sxhJ7W2sRLxVs5l
 krxXAjhvHBbeS6zBN/y+yLmtqffD3C4/bH1GTElryIHQZEivk98AzqZw5S8uJsoh5ZUHivhqf
 D9Re3H2zuHMu6P3Rt+NqysCbq9/Tnb6M20Lc7gGMMzhjrsSralqqQ1123Cu+eWeifYot7rq3G
 UlUkdd+DfMK2SxW1mgJLzkAD1Gb26TfjGqFjIoo0N1gxBH2fFhbdWm1rBs0VT9jVS1jnrGPp1
 /QRs9CUEwjIozhwB73zgTjB95D/3iMKYGS+ATK9lA3xzJyDBDFjTO/SKmuaTJGc0Po2HiCbRS
 EB8z7JbzZ7Ntc11jAcGQ1E5zG0Yz586hFD0XJ94t6G2/y4Cf0I2D+4Wbzha8CWo7bO2XzMdrn
 eG4hy/oVXbdlIWNxFKujiOQmXkl/wn9zKj5U/zPQXsLAnv7o+FsHrLEhyVdiyat0MknjNVsGc
 Jzbhx7ZAce3w/jRWqp/pssRKp4iQyeQ7CZxrThFjBdsIMQ0ylvWLzfENl7fqN+xE/7UUhpHkC
 5uhK5SRXZ8vry/rvVbxFygyIotDeeMa65PvkPaKfTdgTi+25zAZESNuut+byRp8PETYnepAib
 XWG4U8NV9gtudY325+AyhoxFxG9EJMvAMLkWpcve5X/08PWJnEJzaF8jEKKTI6rkShymBfq3l
 I4HCYddACpHIdgVYkHOr2PCPkrxUO6ZuKIm3Kd9K7/2EehY0Bj5nlYn1Dc2pKZo+UeJrhJBHx
 snJh5fnhe1a7DvafZQGTM0Qw==

>> Do you find the proposed software extension generally reasonable?
>>
>> Can any more source code places benefit from such a programming interfa=
ce adjustment?
>> https://elixir.bootlin.com/linux/v6.12-rc2/A/ident/mpi_free
>
> Please submit actual patches using this.
I would appreciate more positive indications according to scope-based reso=
urce management
extensions before.
I hope that change resistance/acceptance can be clarified already.

Would there be a need to make the activation of discussed special macro ca=
lls
depend on other constraints?

Regards,
Markus
