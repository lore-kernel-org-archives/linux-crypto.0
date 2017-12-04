From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 01/10] staging: ccree: remove inline qualifiers
Date: Mon, 4 Dec 2017 12:36:39 +0300
Message-ID: <20171204093639.7ctulxb4v2htqbmj@mwanda>
References: <1512309503-29766-1-git-send-email-gilad@benyossef.com>
 <1512309503-29766-2-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1512309503-29766-2-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Dec 03, 2017 at 01:58:12PM +0000, Gilad Ben-Yossef wrote:
> The ccree drivers was marking a lot of big functions in C file as
> static inline for no good reason. Remove the inline qualifier from
> any but the few truly single line functions.
> 

The compiler is free to ignore inline hints...  It probably would make
single line functions inline anyway.

regards,
dan carpenter
