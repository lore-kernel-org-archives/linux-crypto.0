From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: Regarding integration with cryptodev
Date: Fri, 11 Jul 2008 10:04:04 +0400
Message-ID: <20080711060403.GA10064@2ka.mipt.ru>
References: <001401c8e306$6d821650$900bc70a@dlh.st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Manish RATHI <manish.rathi@st.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.80.65]:35192 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbYGKGER (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Jul 2008 02:04:17 -0400
Content-Disposition: inline
In-Reply-To: <001401c8e306$6d821650$900bc70a@dlh.st.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi.

On Fri, Jul 11, 2008 at 09:00:12AM +0530, Manish RATHI (manish.rathi@st.com) wrote:
> Is there any effort done to make linux crypto api to work with cryptodev?

No.

> How can I use kernel space linux crypto with user space libraries?

You can not.

> Does Linux crypto framework provide async APIs like OCF? What are the pros and cons of Linux crypto in comparison to OCF?

Cryptoapi does much more than OCF has.

> Has anybody tested openswan KLIPS patch with 2.6.24 kernel so that ipsec use OCF?

Unlikely...

There is a work to implement userspace interface for cryptoapi, which
will use all its features, be asynchronous (there is a patch to
implement aio_read/aio_write with crypto file descriptors), although
work is in early development, it promises interesting capabilities.

Check work from Shasi Pulijala <spulijala@amcc.com> and
Loc Ho <lho@amcc.com>

-- 
	Evgeniy Polyakov
