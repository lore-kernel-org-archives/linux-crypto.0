Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A0F43CEC2;
	Tue, 20 Jan 2026 18:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768933458; cv=none; b=SjCxfC5olskmHXucy4TcEXOGmFz7bK+1dsI1xRtJGCCK6Ufq14WIH6xar286YIUdXpB1QEgUcxJtg3MAaah9K3Qr94oyubXj49j2VAuOMRtD+ROHG06W7OEOonWeBVrYJAmDEnJp245okCE74eyhu3hFLgRnkid8cfDb5S8r+5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768933458; c=relaxed/simple;
	bh=laO+s2zBiXudQJg6l9/ECBEXlmXile3qngJMXioXyAw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ut5AHp7ssOavVixWTlUWRopMN2tGgbWSP/fA2DqQ0fc0om+Gaj/ALZ4djek16TcTYQi2XE4bU/NK8uG5xlT12NZOXTDPwnwT1LQhrL15SiQCzEFG9BnXGOCPZ/YuJyxRSmeXQjSsk0A4mxsCTE1dt4mRfdgZh4FFpBJW64hryN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=AqUY9lXl; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="AqUY9lXl"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dwbM41s2Lz1XM0ns;
	Tue, 20 Jan 2026 18:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1768933453; x=1771525454; bh=laO+s2zBiXudQJg6l9/ECBEX
	lmXile3qngJMXioXyAw=; b=AqUY9lXlAQ4tazuUKBYtOVKX+Sxi+fpryjzp/hnc
	Z1AscB9YpGz0GenM7OjEN3g14T9M/Kuce+x+5f3bG4kmckbcwZYJfJq9EyaysY72
	qJw4hePIJKaAvOspdV2bQDFO4HeyNL8JD44+P+BQ14XFhP4xmlsr4FXDo/i4cnMe
	mxRS9QxPfqEku4O18CCxatl0wvE3GFMMsFeS6BDvIQf/ih6+wet/Un5jjJk7Kwu9
	4MDVTUzSLTlaMMbwyaZOfz8lROQZTYXIty0LXRmrI+JGyQesgVrQwNJcCJ0zvbYZ
	jGcUcHjjHU95vSmMp/u05P9C9WLBkOPKCOICmMqwX+l2Zg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id vZGs651jTWFO; Tue, 20 Jan 2026 18:24:13 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dwbLx272pz1XM5jn;
	Tue, 20 Jan 2026 18:24:08 +0000 (UTC)
Message-ID: <16d01754-cab9-4067-a65f-60040ac6d47e@acm.org>
Date: Tue, 20 Jan 2026 10:24:08 -0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH tip/locking/core 0/6] compiler-context-analysis: Scoped
 init guards
To: Marco Elver <elver@google.com>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
 Christoph Hellwig <hch@lst.de>, Steven Rostedt <rostedt@goodmis.org>,
 kasan-dev@googlegroups.com, llvm@lists.linux.dev,
 linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260119094029.1344361-1-elver@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260119094029.1344361-1-elver@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/19/26 1:05 AM, Marco Elver wrote:
> This series proposes a solution to this by introducing scoped init
> guards which Peter suggested, using the guard(type_init)(&lock) or
> scoped_guard(type_init, ..) interface.
Although I haven't had the time yet to do an in-depth review, from a
quick look all patches in this series look good to me.

Thanks,

Bart.
