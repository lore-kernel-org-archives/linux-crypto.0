From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH v2 1/3] ima: use ahash API for file hash calculation
Date: Wed, 02 Jul 2014 11:52:53 -0700
Message-ID: <53B45505.5070507@intel.com>
References: <cover.1404245510.git.d.kasatkin@samsung.com>	<72d68808fd8db2b896a459b120f3e550e5f976c1.1404245510.git.d.kasatkin@samsung.com>	<53B45095.80102@intel.com> <CACE9dm_S-a-ifJN4J+uU4GNy=-oP5h1PrU9x14CY1f0mnPZ-XA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
	linux-ima-devel@lists.sourceforge.net,
	linux-security-module <linux-security-module@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	Dmitry Kasatkin <d.kasatkin@samsung.com>
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58513 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536AbaGBSxI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Jul 2014 14:53:08 -0400
In-Reply-To: <CACE9dm_S-a-ifJN4J+uU4GNy=-oP5h1PrU9x14CY1f0mnPZ-XA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 07/02/2014 11:40 AM, Dmitry Kasatkin wrote:
>> > We should reserve command-line parameters for things that really need
>> > tweaking in early boot or are _needed_ to boot.
...
> Is module param good enough or it should be sysctl?

Doesn't matter to me much.  sysctls seem to be the easiest things to
configure and make persistent.  I'm not sure if the normal
/etc/modprobe.d things work for built-in features, but if they do I'd
say a modparam is fine.
