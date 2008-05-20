From: "Barry G" <mr.scada@gmail.com>
Subject: Hardware Acceleration on Freescale MPC8349
Date: Tue, 20 May 2008 09:01:55 -0700
Message-ID: <61362e760805200901o3a7d3c20g1a9fd9359b5d1215@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.188]:23636 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbYETQB7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 May 2008 12:01:59 -0400
Received: by gv-out-0910.google.com with SMTP id e6so551166gvc.37
        for <linux-crypto@vger.kernel.org>; Tue, 20 May 2008 09:01:57 -0700 (PDT)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

I am trying to get HW accelerated IPsec connections working
on the SEC 2.4 engine in the MPC8349.

I am hoping to use StrongSwan which uses the native XFRM
kernel components.  Unfortunately it looks like the only
working option available to me is the OCF stuff (using the Talitos
driver) which only works with OpenSwan.

Is anyone working on a HW accelerator for the Freescale SEC engine
that XFRM IPsec connections can use?

Thanks,

Barry
