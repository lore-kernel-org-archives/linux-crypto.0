From: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] Export symbol ksize()
Date: Tue, 10 Feb 2009 15:35:03 +0200
Message-ID: <84144f020902100535i4d626a9fj8cbb305120cf332a@mail.gmail.com>
References: <1234272104-10211-1-git-send-email-kirill@shutemov.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Christoph Lameter <cl@linux-foundation.org>,
	Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:58312 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbZBJNfF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Feb 2009 08:35:05 -0500
In-Reply-To: <1234272104-10211-1-git-send-email-kirill@shutemov.name>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 10, 2009 at 3:21 PM, Kirill A. Shutemov
<kirill@shutemov.name> wrote:
> It needed for crypto.ko
>
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>

That's bit terse for a changelog. I did a quick grep but wasn't able
to find the offending call-site. Where is it?

We unexported ksize() because it's a problematic interface and you
almost certainly want to use the alternatives (e.g. krealloc). I think
I need bit more convincing to apply this patch...

                        Pekka
