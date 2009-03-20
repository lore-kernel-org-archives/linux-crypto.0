From: Lee Nipper <lee.nipper@gmail.com>
Subject: Re: Talitos on MPC8548
Date: Fri, 20 Mar 2009 06:11:28 -0500
Message-ID: <49C379E0.2090709@gmail.com>
References: <200903191736.n2JHaCu20819@sierra.gdatech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: "G.Muruganandam" <gmuruga@gdatech.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:25190 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbZCTLLo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Mar 2009 07:11:44 -0400
Received: by qw-out-2122.google.com with SMTP id 8so798113qwh.37
        for <linux-crypto@vger.kernel.org>; Fri, 20 Mar 2009 04:11:41 -0700 (PDT)
In-Reply-To: <200903191736.n2JHaCu20819@sierra.gdatech.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 19, 2009, G.Muruganandam <gmuruga@gdatech.com> wrote:

 > I would like to get a pointer to start testing talitos on the MPC8548 
board.
 > I have linux kernel 2.6.27.18 running on the custom designed MPC8548 
board.

This is how I would approach it:

1) Look at the custom board's .dts file
     and make sure it has a crypto section with properties
     which match those in arch/powerpc/boot/dts/mpc8548cds.dts
     from 2.6.27.18.

2) talitos in 2.6.27.18 implements only ESP IPsec algorithms.
     So if you need h/w accelerated plain cipher or digest
     algorithms,there are not there.

3) If IPsec is what you are interested in using, talitos implements
     aes-cbc and 3des-cbc encryption, and hmac-sha1 & -sha256
     & -md5 authentication. You can try it in 2.6.27.18.
     Turn on the necessary CRYPTO kernel options as well
     as applicable IPsec options.

4) For better IPsec performance, add the talitos patches made since
     2.6.27 which are in the mainline kernel tree.
     (Linux 2.6.29-rc8 includes 7 extra patches).
     These could be added to 2.6.27.18 easily.

Lee

