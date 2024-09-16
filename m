Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D540414A62E;
	Mon, 16 Sep 2024 11:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726485844; cv=none; b=YCoOmPSCo7qtUP6vJGKBh1iR+w5BgJS/mugt3Z70oPsMBBlLfL5u/+VWsb2cA3ju3ga1vFS3yAL334dHLj+tSE/cTbWuKYELr86tALwAUwlNe0yvjds1B8aVOXsy3bAohCAybPD9eCQnM9NXIjtCLTxXJcju4Jbc7tIVcubVgg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726485844; c=relaxed/simple;
	bh=Wz135zrKOqcehDlCtIoMWVe0zViljMgxjrKPTo1q+s4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=neB2JPED4cIaECCWxAnMhBMB3gi8q2QTUg/LLZENDJqWbkUgST8/6R5/AbX2NAPoM5vIn7fT8RgHPViGgote1rUGWxqfSqo1fjfCbMvrfEdiBPmzok+pv0hZxVhkZEfeO51v6frLc/8sa2mZ6oHYCJmYOLJ+eeXSZR1vCtEuYI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=LtE70Y6o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="LtE70Y6o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F73C4CEC7;
	Mon, 16 Sep 2024 11:24:02 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="LtE70Y6o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1726485839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9p2M90j/wEeRkSmvHw/p+Br0CA14kYcSjCfs9P4fkC8=;
	b=LtE70Y6oDQq0NSQ2Rb0nSKz4CWfcF6pa9zn0turKfHnFLij4UWPN/1W9pORiFQfp8As4Dv
	Q8nyjZx844X3t5HnLgdkwKP11yLWUYxGJyToCqzx1ATTaomLTdo+SA2+1ZnkO5hclYvLMV
	nDzfB6/MBNiktnkXOxEBEbTvjVz0Ot0=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id bcbeea86 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Mon, 16 Sep 2024 11:23:58 +0000 (UTC)
Date: Mon, 16 Sep 2024 13:23:56 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Stefan Liebler <stli@linux.ibm.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH 7/7] s390/vdso: Wire up getrandom() vdso implementation
Message-ID: <ZugVTNJT9SVBOxvI@zx2c4.com>
References: <20240913130544.2398678-1-hca@linux.ibm.com>
 <20240913130544.2398678-8-hca@linux.ibm.com>
 <ZuRWmJTWqmD92D8d@zx2c4.com>
 <ZuRYoVIrg28kBKqb@zx2c4.com>
 <20240913173206.30385-C-hca@linux.ibm.com>
 <ZuSRKLFdYI1gCHh9@zx2c4.com>
 <20240914174246.8394-A-hca@linux.ibm.com>
 <Zuf1oYveC0rryg_6@zx2c4.com>
 <20240916110108.20933-A-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240916110108.20933-A-hca@linux.ibm.com>

On Mon, Sep 16, 2024 at 01:01:08PM +0200, Heiko Carstens wrote:
> Hi Jason,
> 
> > On Sat, Sep 14, 2024 at 07:42:46PM +0200, Heiko Carstens wrote:
> > > Please feel free to change the code in whatever way you like.
> > > If you prefer separate patches, I will provide them.
> > 
> > Just wanted to make sure you saw https://lore.kernel.org/all/20240914231241.3647749-1-Jason@zx2c4.com/
> 
> Yes, looks good to me. I just gave it also a quick test.
> 
> FWIW, I think the tags for the commit message should be
> 
> Co-developed-by: Heiko Carstens <hca@linux.ibm.com>
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>

Thanks, fixed.
