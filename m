From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 0/2] Add in-kernel /dev/random equivalent
Date: Fri, 06 Jun 2014 14:23:23 +0200
Message-ID: <33386917.yDDF1yg5fp@tauon>
References: <1937020.H2HvEFgXrB@myon.chronox.de> <20140606115900.GA4367@amd.pavel.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Theodore Ts'o <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140606115900.GA4367@amd.pavel.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Freitag, 6. Juni 2014, 13:59:00 schrieb Pavel Machek:

Hi Pavel,

>On Mon 2014-05-12 00:36:01, Stephan Mueller wrote:
>> Hi,
>> 
>> as discussed in thread [1], an in-kernel equivalent to the blocking
>> /dev/random device behavior is suggested. This in-kernel blocking
>> access to the RNG can be used to seed deterministic random number
>> generators with random numbers that are directly backed by the
>> underlying noise sources.
>> 
>> The following patch implements this concept by adding a third output
>> pool, the kernel_pool that is only accessible inside the kernel.
>> That kernel_pool feeds the blocking operation API calls to obtain
>> random numbers.
>> 
>> Please find a test kernel module attached. You can unload it even
>> while the collection process is ongoing.
>> 
>> [1] https://lkml.org/lkml/2014/4/27/174
>> 
>> Stephan Mueller (2):
>>   Addition of kernel_pool
>>   Asynchronous and syncronous API for accessing kernel_pool
>>  
>>  drivers/char/random.c  | 163
>> 
>> +++++++++++++++++++++++++++++++++++++++++++++----
>> 
>>  include/linux/random.h |  16 +++++
>>  2 files changed, 166 insertions(+), 13 deletions(-)
>
> * Copyright (c) 2014
> *
> * Permission is hereby granted, free of charge, to any person
> *obtaining a copy
> * of this software and associated documentation files (the
> *"Software"), to deal
> * in the Software without restriction, including without limitation
> *the rights
> * to use, copy, modify, merge, publish, distribute, sublicense,
> *and/or sell
> * copies of the Software, and to permit persons to whom the Software
> *is
> * furnished to do so, subject to the following conditions:
>
>...but module_license says this is GPL...

Thank you very much for the hint -- this is an oversight on my behalf. I 
wanted the test kernel code to be licensed in a dual BSD/GPLv2 style.

As this is just a test module to demonstrate the appropriateness of the 
offered patch, I hope you can still live with it until a potential new 
submission is provided. Though, if you insist I can resubmit the test 
module with the dual BSD/GPLv2 clause.

Ciao
Stephan
