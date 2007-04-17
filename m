From: "Francis Moreau" <francis.moro@gmail.com>
Subject: Re: [CRYPTO] is it really optimized ?
Date: Tue, 17 Apr 2007 16:01:51 +0200
Message-ID: <38b2ab8a0704170701p69fd547dwe3e2523ba5798b55@mail.gmail.com>
References: <20070417130431.GA8685@2ka.mipt.ru>
	 <E1HdnwX-0005U1-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
	helge.hafting@aitel.hist.no, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.227]:37743 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398AbXDQOBx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Apr 2007 10:01:53 -0400
Received: by wx-out-0506.google.com with SMTP id h31so2040433wxd
        for <linux-crypto@vger.kernel.org>; Tue, 17 Apr 2007 07:01:52 -0700 (PDT)
In-Reply-To: <E1HdnwX-0005U1-00@gondolin.me.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 4/17/07, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Yep.  We don't need such a flag anyway.  All we need is a way to tweak
> the priority and Bob's your uncle.
>

Could you elaborate please, I don't see how you prevent others users
to use this module with priority.

Priority is a stuff that tells you which aes implementation to use but
it does not prevent an implementation to be used several times...

Thanks
-- 
Francis
