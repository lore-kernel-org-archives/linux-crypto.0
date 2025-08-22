Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8AA21255D;
	Fri, 22 Aug 2025 11:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755863171; cv=none; b=cTrDOcwywOjEkLIhyC4yqvQknmKXDUGRlUFQACn/2rjcooTFb9oySLGCk95r8qQTodUV5TV8ZiqO8COIb873+2//T7vPTkH1J0RO+F+Lcwx/wNTnu222E+La3iUFlfr5W9oqI9Ao0wHQUuwPtcE9dpZvrV2IUemRPLKXjVyJ1AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755863171; c=relaxed/simple;
	bh=AIARX0YENOFc2FlWerL+nadOCvhdnZEf8W7BMc8W2ag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Npe1vU3r8lkS56mmD6bJMrO1XblXESENHlOLYVAZjRCZ55C7XE28Z6V6R3D5IAq+S69t5XuYiuq/4qNSl+COXPjB9IhLWu3QKimtNmep1P0lIC9pwrsuD2Yy1I1EFEN6znDoUsN57hJdvNHRNmJm2HdLy4PiSOmss0Ql7fUt6nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jxZyNUTA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jxZyNUTA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C9EC4CEED;
	Fri, 22 Aug 2025 11:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755863171;
	bh=AIARX0YENOFc2FlWerL+nadOCvhdnZEf8W7BMc8W2ag=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jxZyNUTANHNe+LLw1XjsZbVLAAvXAr1atgSnwtyRHg7jiMGl9hgI94G7iV20FRaZz
	 4nSTTXhdbxmfe1cnQHTqhFC252Lp7vzK6a2tn9IKqzCL4LrWpUBAJxaVAuhIIC3rOA
	 hqhrjrhAO0mjxhCVBRJpUWoo6mKN7k43TZD3m+70=
Date: Fri, 22 Aug 2025 13:46:07 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: zhangfei.gao@linaro.org, wangzhou1@hisilicon.com,
	linux-kernel@vger.kernel.org, linuxarm@huawei.com,
	linux-crypto@vger.kernel.org, fanghao11@huawei.com,
	shenyang39@huawei.com, qianweili@huawei.com,
	linwenkai6@hisilicon.com, liulongfang@huawei.com
Subject: Re: [PATCH 3/4] uacce: implement mremap in uacce_vm_ops to return
 -EPERM
Message-ID: <2025082208-coauthor-pagan-e72c@gregkh>
References: <20250822103904.3776304-1-huangchenghai2@huawei.com>
 <20250822103904.3776304-4-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250822103904.3776304-4-huangchenghai2@huawei.com>

On Fri, Aug 22, 2025 at 06:39:03PM +0800, Chenghai Huang wrote:
> From: Yang Shen <shenyang39@huawei.com>
> 
> The current uacce_vm_ops does not support the mremap operation of
> vm_operations_struct. Implement .mremap to return -EPERM to remind
> users

Why is this needed?  If mremap is not set, what is the value returned?

And why is -EPERM the correct value to return here?  That's not what the
man pages say is valid :(

thanks,

greg k-h
