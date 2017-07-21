From: Oliver Mangold <o.mangold@gmail.com>
Subject: Re: Poor RNG performance on Ryzen
Date: Fri, 21 Jul 2017 16:55:12 +0200
Message-ID: <c1010252-5648-85de-d71b-750aa2881b64@gmail.com>
References: <1218e9b7-4eeb-d8a0-02b2-8ddd672ec454@gmail.com>
 <20170721092656.GA18604@wintermute>
 <09c9be2b-8b4d-ee06-8071-4f748fdb5970@gmail.com>
 <20170721144741.4igkvsd2fowptsy2@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37610 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754533AbdGUOzP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jul 2017 10:55:15 -0400
Received: by mail-wm0-f51.google.com with SMTP id e131so16278179wme.0
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jul 2017 07:55:15 -0700 (PDT)
Received: from laptop-olli.localdomain ([2a02:8070:7b0:ed00:a81a:6d6:cddf:9db4])
        by smtp.googlemail.com with ESMTPSA id r128sm1423949wmb.27.2017.07.21.07.55.13
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jul 2017 07:55:13 -0700 (PDT)
In-Reply-To: <20170721144741.4igkvsd2fowptsy2@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 21.07.2017 16:47, Theodore Ts'o wrote:
> On Fri, Jul 21, 2017 at 01:39:13PM +0200, Oliver Mangold wrote:
>> Better, but obviously there is still much room for improvement by reducing
>> the number of calls to RDRAND.
> Hmm, is there some way we can easily tell we are running on Ryzen?  Or
> do we believe this is going to be true for all AMD devices?
I would like to note that my first measurement on Broadwell suggest that 
the current frequency of RDRAND calls seems to slow things down on Intel 
also (but not as much as on Ryzen).
