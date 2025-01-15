Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8714C22E407;
	Wed, 15 Jan 2025 07:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736927924; cv=none; b=PeAmyQkZOZM4WpoupcEwcyaQz6YxEIreABJjHc4tpRrlAIAokl0Z8ecXpW2e8oL3VkAZ3EPdBWjClnHa8IkgD5UR97Iq7lVSu+3rRvYZKwUg/5x9VskpqwLxMsY6n1d6l53ln5X1ulGnOuNkSIaAEw6E0kiI7vqEz4IVlIUNCB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736927924; c=relaxed/simple;
	bh=amX4pkedsohY08I1v/l+6Iok3zn1JGPQRZL5AWH5uvU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jZPL2gXrCDH5zJPJIRpiXIa2O8zMZ1F4i1KQmT3siG1s4uyF6Ic98EtaA8HeAHlVuYBmBEmXF7H/86jjWFYDMvopUOABHm5HusZwjMjuC1EH1WAWtIz6yCDCi48L+gfpUpEiF8Ij3Rr49oNvgPhnlYTeEVp2UAenV3wLROOdSQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ymKZN5Yw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ymKZN5Yw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5961CC4CEDF;
	Wed, 15 Jan 2025 07:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736927924;
	bh=amX4pkedsohY08I1v/l+6Iok3zn1JGPQRZL5AWH5uvU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ymKZN5YwIQFqTmDqX5WbvifyxRmiW0WjIgiMgUuHYseeq9yY/mOKub8lB4IqzJhLn
	 2Mpra6k/Ct6hhqCsRsd6Cg+902hzXHOLXJ4FVTcDys8G75U4+M2I/CEz7jARyx4jyt
	 v0nk50DElCJLiAvCrTL8sZzpMzlLo1f/ThO7n57I=
Date: Wed, 15 Jan 2025 08:58:40 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Qunqin Zhao <zhaoqunqin@loongson.cn>
Cc: Xi Ruoyao <xry111@xry111.site>, Arnd Bergmann <arnd@arndb.de>,
	Lee Jones <lee@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	"derek.kiernan@amd.com" <derek.kiernan@amd.com>,
	"dragan.cvetic@amd.com" <dragan.cvetic@amd.com>,
	Yinggang Gu <guyinggang@loongson.cn>
Subject: Re: [PATCH v1 3/3] misc: ls6000se-sdf: Add driver for Loongson
 6000SE SDF
Message-ID: <2025011527-antacid-spilt-cbef@gregkh>
References: <20250114095527.23722-1-zhaoqunqin@loongson.cn>
 <20250114095527.23722-4-zhaoqunqin@loongson.cn>
 <ee65851c-4149-4927-a2e7-356cdce2ba25@app.fastmail.com>
 <97000576d4ba6d94cea70363e321665476697052.camel@xry111.site>
 <2025011407-muppet-hurricane-196f@gregkh>
 <122aab11-f657-a48e-6b83-0e01ddd20ed3@loongson.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <122aab11-f657-a48e-6b83-0e01ddd20ed3@loongson.cn>

On Wed, Jan 15, 2025 at 10:58:52AM +0800, Qunqin Zhao wrote:
> 
> 在 2025/1/14 下午9:21, Greg Kroah-Hartman 写道:
> > On Tue, Jan 14, 2025 at 06:43:24PM +0800, Xi Ruoyao wrote:
> > > On Tue, 2025-01-14 at 11:17 +0100, Arnd Bergmann wrote:
> > > > On Tue, Jan 14, 2025, at 10:55, Qunqin Zhao wrote:
> > > > > Loongson Secure Device Function device supports the functions specified
> > > > > in "GB/T 36322-2018". This driver is only responsible for sending user
> > > > > data to SDF devices or returning SDF device data to users.
> > > > I haven't been able to find a public version of the standard
> > > A public copy is available at
> > > https://openstd.samr.gov.cn/bzgk/gb/newGbInfo?hcno=69E793FE1769D120C82F78447802E14F,
> > > pressing the blue "online preview" button, enter a captcha and you can
> > > see it.  But the copy is in Chinese, and there's an explicit notice
> > > saying translating this copy is forbidden, so I cannot translate it for
> > > you either.
> > > 
> > > > but
> > > > from the table of contents it sounds like this is a standard for
> > > > cryptographic functions that would otherwise be implemented by a
> > > > driver in drivers/crypto/ so it can use the normal abstractions
> > > > for both userspace and in-kernel users.
> > > > 
> > > > Is there some reason this doesn't work?
> > > I'm not an lawyer but I guess contributing code for that may have some
> > > "cryptography code export rule compliance" issue.
> > Issue with what?  And why?  It's enabling the functionality of the
> > hardware either way, so the same rules should apply no matter where the
> > driver ends up in or what apis it is written against, right?
> 
> SDF and tpm2.0 are both  "library specifications",  which means that
> 
> it supports a wide variety of functions not only cryptographic functions,
> 
> but unlike tpm2.0, SDF is only used in China.
> 
> You can refer to the tpm2.0 specification:
> https://trustedcomputinggroup.org/resource/tpm-library-specification/

So this is an accelerator device somehow?  If it provides crypto
functions, it must follow the crypto api, you can't just provide a "raw"
char device node for it as that's not going to be portable at all.
Please fit it into the proper kernel subsystem for the proper
user/kernel api needed to drive this hardware.

thanks,

greg k-h
