From: Felipe Contreras <felipe.contreras@gmail.com>
Subject: Re: [PATCH 3/7] crypto: testmgr: fix warning
Date: Thu, 12 Nov 2009 02:32:10 +0200
Message-ID: <94a0d4530911111632w4767b704v887629dcf0f2b0e1@mail.gmail.com>
References: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com>
	 <1255906474-25091-4-git-send-email-felipe.contreras@gmail.com>
	 <alpine.LSU.2.00.0910191551030.8582@wotan.suse.de>
	 <4ADC707E.2040802@redhat.com> <4ADC71C4.3020805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Neil Horman <nhorman@tuxdriver.com>,
	linux-crypto@vger.kernel.org
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:64183 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759678AbZKLAcF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Nov 2009 19:32:05 -0500
In-Reply-To: <4ADC71C4.3020805@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 19, 2009 at 4:03 PM, Jarod Wilson <jarod@redhat.com> wrote:
> So yeah, I rescind my claim that initializing err to 0 is incorrect, I think
> that's just fine.

So is this acked? Who will merge it?

-- 
Felipe Contreras
