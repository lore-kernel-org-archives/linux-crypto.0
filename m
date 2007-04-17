From: "Francis Moreau" <francis.moro@gmail.com>
Subject: Re: [CRYPTO] is it really optimized ?
Date: Tue, 17 Apr 2007 18:18:42 +0200
Message-ID: <38b2ab8a0704170918u72792c0ei591fea98eac2681d@mail.gmail.com>
References: <20070417130431.GA8685@2ka.mipt.ru>
	 <E1HdnwX-0005U1-00@gondolin.me.apana.org.au>
	 <38b2ab8a0704170701p69fd547dwe3e2523ba5798b55@mail.gmail.com>
	 <20070417150859.GA9512@2ka.mipt.ru>
	 <38b2ab8a0704170834i1856886nafeeec692f49fea0@mail.gmail.com>
	 <20070417155725.GA18959@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
	helge.hafting@aitel.hist.no, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.229]:50338 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031141AbXDQQSn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Apr 2007 12:18:43 -0400
Received: by nz-out-0506.google.com with SMTP id s1so1525209nze
        for <linux-crypto@vger.kernel.org>; Tue, 17 Apr 2007 09:18:43 -0700 (PDT)
In-Reply-To: <20070417155725.GA18959@2ka.mipt.ru>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 4/17/07, Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
>
> If there are another users, then flag should not be set.

depends if there's a 'generic' algo that can be used at the same time.
Admin should know that.

> If there are no another users, your code already has exclusive access.

sorry I don't understand that.

> One can not know if there will be any additional users at all (consider
> the case when new encrypted block device or ipsec negotiation started
> some time after module was loaded).
>

well I should say administrator should know.

-- 
Francis
