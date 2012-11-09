From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v3 5/9] kernel: padata : use __this_cpu_read per-cpu
 helper
Date: Fri, 9 Nov 2012 20:13:36 +0000
Message-ID: <0000013ae6ce639f-3b5554d1-c002-40b3-80e8-06fa8f1b7a1e-000000@email.amazonses.com>
References: <509C68A0.1070004@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: steffen.klassert@secunet.com,
	Kernel-Maillist <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Shan Wei <shanwei88@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:47321 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752655Ab2KIUNh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Nov 2012 15:13:37 -0500
In-Reply-To: <509C68A0.1070004@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 9 Nov 2012, Shan Wei wrote:

> For bottom halves off, __this_cpu_read is better.

Reviewed-by: Christoph Lameter <cl@linux.com>
