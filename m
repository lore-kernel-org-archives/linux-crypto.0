Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80EC533C8
	for <linux-crypto@vger.kernel.org>; Fri,  1 Mar 2024 16:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709312379; cv=none; b=d1G5kUbC18U748InxyFWJ2ri+i/N68DuvnlPwLABe8I05dbb/tM3eTZxRaFh2znIuWWoy19ksKBcsVsmqGmNsxTVy7SlUFBChz1QV4oRp4knmxsd4UqIXjPoUJSYs9KINVbVmG0YiVA1CFbShbsZZnlJa2ObLUelpJC3HlrEPN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709312379; c=relaxed/simple;
	bh=hvfj7eDHi5/VfND/z+So1fqZmTlSseuKtbHWlEFstg8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=FC6NKuiaCPh6XNkySUEjM8JAhN97GuGnOWPtabTCm+mE2mvjqLeCd6pWNHovhvsO2SpI5OzFt/9RjRIcn4I1+0Qz7EHnF/zwdy9QftQg7cOB38zE0DKRJ+XQVW3TC+Fw5LOOkTmV+Pi7kGMrtru6Egak2fKZz+uqTuT0x252pCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=kIfwdPDM; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="kIfwdPDM"
Received: from [100.64.208.161] (unknown [20.29.225.195])
	by linux.microsoft.com (Postfix) with ESMTPSA id 0972A20B74C0;
	Fri,  1 Mar 2024 08:59:37 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0972A20B74C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1709312378;
	bh=7DK/bolbsv/7kYxe6fpAW7baaMWI/EFEO0wfE49dZsI=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=kIfwdPDMWV3AvuUF6BTPpC3q4UiTbK/ZGiwlO+vputrVYdcyjq51cV9iVbthJKFyH
	 GmLLHlKjXuqmuCRQOrIoELaCrhYdHTynmBReJT3wbUd0pWqwn+XKMZYil3RuBOi8NI
	 ihW0pe9PNXXO+OKspFWWgSTwd4GIIUkK5mkKm/6o=
Message-ID: <82a5cacf-73f5-44e5-ab65-0ff9554037b3@linux.microsoft.com>
Date: Fri, 1 Mar 2024 08:59:37 -0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: https over ESP is not working in kernel version 5.10.199
To: "Jayalakshmi Manunath Bhat ," <bhat.jayalakshmi@gmail.com>,
 linux-crypto@vger.kernel.org
References: <CALq8RvJDQ9U4x_Beew0jGQqSQtm3TGXh9m5aSvrzPZeft0h0Kg@mail.gmail.com>
Content-Language: en-US
From: Easwar Hariharan <eahariha@linux.microsoft.com>
In-Reply-To: <CALq8RvJDQ9U4x_Beew0jGQqSQtm3TGXh9m5aSvrzPZeft0h0Kg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/1/2024 4:35 AM, Jayalakshmi Manunath Bhat , wrote:
> Hi All.
> 
> On our device I am able to establish IPsec IKEv1 rules successfully on
> kernel version 5.10.199. Ping, Telnet, http (port 80) etc works fine.
> However when I am trying to https to device, operation fails and error
> is in xfrm_input.c and error is
> if (nexthdr == -EBADMSG), nexthdr is EBADMSG and the packet is
> dropped. I do not understand why https fails.
> 
> Have any of you come across this error?
> 
> Regards,
> Jaya

Can you try with a more recent kernel? Try mainline, or a recent 6.6.* stable kernel.

Thanks,
Easwar
