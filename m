From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: Debugging Talitos
Date: Mon, 21 Jul 2008 17:50:04 -0500
Message-ID: <20080721175004.642fc876.kim.phillips@freescale.com>
References: <61362e760807211527w550f070dk37fd59454f839c3d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: "Barry G" <mr.scada@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from de01egw02.freescale.net ([192.88.165.103]:58604 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbYGUWuI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Jul 2008 18:50:08 -0400
In-Reply-To: <61362e760807211527w550f070dk37fd59454f839c3d@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 21 Jul 2008 15:27:33 -0700
"Barry G" <mr.scada@gmail.com> wrote:

> in and start printk'ing everything or ?  Do I need other changes from
> the tree than the taliltos driver?
> 
> BTW, here is the relevent entry in the DTS:

>    compatible = "talitos";

yes, you need the new bindings, I sent them as a separate patch to go
through the powerpc tree:

http://patchwork.ozlabs.org/linuxppc/patch?id=19542

(also available as commit 3fd4473 in Linus' tree)

Kim
