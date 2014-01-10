From: Clemens Ladisch <clemens@ladisch.de>
Subject: Re: [RFC PATCH] char: random: stir the output pools differently when
 the random_write lenght allows splitting the seed
Date: Fri, 10 Jan 2014 09:13:57 +0100
Message-ID: <52CFABC5.5030806@ladisch.de>
References: <42f6dc88535d5ecdab13b1376db7ccbbbc550600.1389297772.git.aquini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Stephan Mueller <stephan.mueller@atsec.com>
To: Rafael Aquini <aquini@redhat.com>, Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtprelay03.ispgateway.de ([80.67.31.41]:60292 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbaAJIYQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Jan 2014 03:24:16 -0500
In-Reply-To: <42f6dc88535d5ecdab13b1376db7ccbbbc550600.1389297772.git.aquini@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Rafael Aquini wrote:
> This patch introduces changes to the random_write method so it can split the
> given seed and completely stir the output pools with different halves of it,
> when seed lenght allows us doing so.
>
> -	ret = write_pool(&blocking_pool, buffer, count);
> +	ret = write_pool(pool1, buffer, count1);
>  	if (ret)
>  		return ret;
> -	ret = write_pool(&nonblocking_pool, buffer, count);
> +	ret = write_pool(pool2, buffer + offset, count2);

Doesn't this assume that both halves of the buffer contain some
(uncredited) entropy?  In other words, wouldn't this result in worse
randomness for pool2 if the second half of the buffer contains just zero
padding?


Regards,
Clemens
