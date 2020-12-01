Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B76DAC64E7B
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 14:27:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B79A20758
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 14:27:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="M8mCvK/p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729140AbgLAO1j (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Dec 2020 09:27:39 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:44754 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726402AbgLAO1j (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Dec 2020 09:27:39 -0500
Received: from [192.168.254.6] (unknown [50.46.158.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 82EC113C2B0;
        Tue,  1 Dec 2020 06:26:57 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 82EC113C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1606832818;
        bh=P52pheZEkg1QxXRBCDi1Lm5Y6Qq/5VvucvGDF7/aDEE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=M8mCvK/penPob4bT7qAudjYdNZQlD8kTu28D8J+jBpZXBc8ibBDLXxpwTL8DdDtwZ
         IPjcntwVaAaVF0y+/B2kv1Exq6yxB0/pyj4AmzFqeueGT9MX4YRPW6CU8hASeYnvcp
         Zx6Gr7B3CRW2mZRpBw1ximzUIVHuHclVLKQtxBuk=
Subject: Re: [PATCH] crypto: aesni - add ccm(aes) algorithm implementation
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steve deRosier <derosier@cal-sierra.com>
References: <20201129182035.7015-1-ardb@kernel.org>
 <4e850713-af8b-f81f-bf3d-f4ee5185d99f@candelatech.com>
 <CAMj1kXGt_sjyBH1veEEEizHjUMWEkuTUicxmhbLjQXnJ9LXGpw@mail.gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <140b7c64-a308-6546-2fb9-a00218e5c526@candelatech.com>
Date:   Tue, 1 Dec 2020 06:26:57 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CAMj1kXGt_sjyBH1veEEEizHjUMWEkuTUicxmhbLjQXnJ9LXGpw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/30/20 10:32 PM, Ard Biesheuvel wrote:
> On Mon, 30 Nov 2020 at 23:48, Ben Greear <greearb@candelatech.com> wrote:
>>
>> On 11/29/20 10:20 AM, Ard Biesheuvel wrote:
>>> From: Steve deRosier <ardb@kernel.org>
>>>
>>> Add ccm(aes) implementation from linux-wireless mailing list (see
>>> http://permalink.gmane.org/gmane.linux.kernel.wireless.general/126679).
>>>
>>> This eliminates FPU context store/restore overhead existing in more
>>> general ccm_base(ctr(aes-aesni),aes-aesni) case in MAC calculation.
>>>
>>> Suggested-by: Ben Greear <greearb@candelatech.com>
>>> Co-developed-by: Steve deRosier <derosier@cal-sierra.com>
>>> Signed-off-by: Steve deRosier <derosier@cal-sierra.com>
>>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>>> ---
>>> Ben,
>>>
>>> This is almost a rewrite of the original patch, switching to the new
>>> skcipher API, using the existing SIMD helper, and drop numerous unrelated
>>> changes. The basic approach is almost identical, though, so I expect this
>>> to perform on par or perhaps slightly faster than the original.
>>>
>>> Could you please confirm with some numbers?
>>
>> I tried this on my apu2 platform, here is perf top during a TCP download using
>> rx-sw-crypt (ie, the aesni cpu decrypt path):
>>
>>     18.77%  [kernel]                            [k] acpi_idle_enter
>>     14.68%  [kernel]                            [k] kernel_fpu_begin
>>      4.45%  [kernel]                            [k] __crypto_xor
>>      3.46%  [kernel]                            [k] _aesni_enc1
>>
>> Total throughput is 127Mbps or so.  This is with your patch applied to 5.8.0+
>> kernel (it applied clean with 'git am')
>>
>> Is there a good way to verify at runtime that I've properly applied your patch?
>>
>> On my 5.4 kernel with the old version of the patch installed, I see 253Mbps throughput,
>> and perf-top shows:
>>
>>     13.33%  [kernel]                            [k] acpi_idle_do_entry
>>      9.21%  [kernel]                            [k] _aesni_enc1
>>      4.49%  [unknown]                           [.] 0x00007fbc3f00adb6
>>      4.34%  [unknown]                           [.] 0x00007fbc3f00adba
>>      3.85%  [kernel]                            [k] memcpy
>>
>>
>> So, new patch is not working that well for me...
>>
> 
> That is odd. The net number of invocations of kernel_fpu_begin()
> should be the same, so I cannot explain why they suddenly take more
> time. I am starting to think that this is a different issue
> altogether.
> 
> One thing that you could try is dropping the '.cra_alignmask' line as
> we don't actually need it, but I am skeptical that this is the cause
> of this.

Here is tcrypt output from the 5.8 kernel with your patch:

               testing speed of rfc4106(gcm(aes)) (rfc4106-gcm-aesni) encryption
[54886.223056] test 0 (160 bit key, 16 byte blocks):
[54887.222241] 723747 operations in 1 seconds (11579952 bytes)
[54887.222274] test 1 (160 bit key, 64 byte blocks):
[54888.222216] 676632 operations in 1 seconds (43304448 bytes)
[54888.222251] test 2 (160 bit key, 256 byte blocks):
[54889.222178] 485715 operations in 1 seconds (124343040 bytes)
[54889.222197] test 3 (160 bit key, 512 byte blocks):
[54890.222169] 355708 operations in 1 seconds (182122496 bytes)
[54890.222188] test 4 (160 bit key, 1024 byte blocks):
[54891.222190] 237094 operations in 1 seconds (242784256 bytes)
[54891.222210] test 5 (160 bit key, 2048 byte blocks):
[54892.222169] 151576 operations in 1 seconds (310427648 bytes)
[54892.222189] test 6 (160 bit key, 4096 byte blocks):
[54893.222182] 89871 operations in 1 seconds (368111616 bytes)
[54893.222230] test 7 (160 bit key, 8192 byte blocks):
[54894.222144] 47446 operations in 1 seconds (388677632 bytes)
[54894.232292]
                testing speed of gcm(aes) (generic-gcm-aesni) encryption
[54894.232310] test 0 (128 bit key, 16 byte blocks):
[54895.232121] 744793 operations in 1 seconds (11916688 bytes)
[54895.232139] test 1 (128 bit key, 64 byte blocks):
[54896.232147] 693209 operations in 1 seconds (44365376 bytes)
[54896.232166] test 2 (128 bit key, 256 byte blocks):
[54897.232108] 494839 operations in 1 seconds (126678784 bytes)
[54897.232127] test 3 (128 bit key, 512 byte blocks):
[54898.232129] 356805 operations in 1 seconds (182684160 bytes)
[54898.232148] test 4 (128 bit key, 1024 byte blocks):
[54899.232093] 238977 operations in 1 seconds (244712448 bytes)
[54899.232112] test 5 (128 bit key, 2048 byte blocks):
[54900.232086] 151400 operations in 1 seconds (310067200 bytes)
[54900.232107] test 6 (128 bit key, 4096 byte blocks):
[54901.232080] 88499 operations in 1 seconds (362491904 bytes)
[54901.232128] test 7 (128 bit key, 8192 byte blocks):
[54902.232073] 46508 operations in 1 seconds (380993536 bytes)
[54902.232093] test 8 (192 bit key, 16 byte blocks):
[54903.232055] 734289 operations in 1 seconds (11748624 bytes)
[54903.232074] test 9 (192 bit key, 64 byte blocks):
[54904.232046] 676257 operations in 1 seconds (43280448 bytes)
[54904.232066] test 10 (192 bit key, 256 byte blocks):
[54905.232037] 480367 operations in 1 seconds (122973952 bytes)
[54905.232057] test 11 (192 bit key, 512 byte blocks):
[54906.232028] 344775 operations in 1 seconds (176524800 bytes)
[54906.232048] test 12 (192 bit key, 1024 byte blocks):
[54907.232021] 246743 operations in 1 seconds (252664832 bytes)
[54907.232041] test 13 (192 bit key, 2048 byte blocks):
[54908.232013] 149042 operations in 1 seconds (305238016 bytes)
[54908.232033] test 14 (192 bit key, 4096 byte blocks):
[54909.232034] 83689 operations in 1 seconds (342790144 bytes)
[54909.232053] test 15 (192 bit key, 8192 byte blocks):
[54910.232004] 43424 operations in 1 seconds (355729408 bytes)
[54910.232042] test 16 (256 bit key, 16 byte blocks):
[54911.232030] 720990 operations in 1 seconds (11535840 bytes)
[54911.232050] test 17 (256 bit key, 64 byte blocks):
[54912.232006] 666866 operations in 1 seconds (42679424 bytes)
[54912.232054] test 18 (256 bit key, 256 byte blocks):
[54913.231997] 459305 operations in 1 seconds (117582080 bytes)
[54913.232018] test 19 (256 bit key, 512 byte blocks):
[54914.231958] 322779 operations in 1 seconds (165262848 bytes)
[54914.231979] test 20 (256 bit key, 1024 byte blocks):
[54915.231970] 229525 operations in 1 seconds (235033600 bytes)
[54915.231990] test 21 (256 bit key, 2048 byte blocks):
[54916.231975] 137955 operations in 1 seconds (282531840 bytes)
[54916.231995] test 22 (256 bit key, 4096 byte blocks):
[54917.231998] 75876 operations in 1 seconds (310788096 bytes)
[54917.232035] test 23 (256 bit key, 8192 byte blocks):
[54918.231938] 39803 operations in 1 seconds (326066176 bytes)
[54918.232046]
                testing speed of rfc4106(gcm(aes)) (rfc4106-gcm-aesni) decryption
[54918.232060] test 0 (160 bit key, 16 byte blocks):
[54919.231914] 711193 operations in 1 seconds (11379088 bytes)
[54919.231933] test 1 (160 bit key, 64 byte blocks):
[54920.231912] 683171 operations in 1 seconds (43722944 bytes)
[54920.231932] test 2 (160 bit key, 256 byte blocks):
[54921.231926] 490569 operations in 1 seconds (125585664 bytes)
[54921.231946] test 3 (160 bit key, 512 byte blocks):
[54922.231904] 354731 operations in 1 seconds (181622272 bytes)
[54922.231938] test 4 (160 bit key, 1024 byte blocks):
[54923.231879] 236161 operations in 1 seconds (241828864 bytes)
[54923.231930] test 5 (160 bit key, 2048 byte blocks):
[54924.231897] 148859 operations in 1 seconds (304863232 bytes)
[54924.231917] test 6 (160 bit key, 4096 byte blocks):
[54925.231866] 87114 operations in 1 seconds (356818944 bytes)
[54925.231885] test 7 (160 bit key, 8192 byte blocks):
[54926.231888] 46273 operations in 1 seconds (379068416 bytes)
[54926.232049]
                testing speed of gcm(aes) (generic-gcm-aesni) decryption
[54926.232064] test 0 (128 bit key, 16 byte blocks):
[54927.231841] 743417 operations in 1 seconds (11894672 bytes)
[54927.231892] test 1 (128 bit key, 64 byte blocks):
[54928.231832] 708360 operations in 1 seconds (45335040 bytes)
[54928.231851] test 2 (128 bit key, 256 byte blocks):
[54929.231853] 501092 operations in 1 seconds (128279552 bytes)
[54929.231872] test 3 (128 bit key, 512 byte blocks):
[54930.231830] 362779 operations in 1 seconds (185742848 bytes)
[54930.231848] test 4 (128 bit key, 1024 byte blocks):
[54931.231808] 238285 operations in 1 seconds (244003840 bytes)
[54931.231828] test 5 (128 bit key, 2048 byte blocks):
[54932.231800] 149171 operations in 1 seconds (305502208 bytes)
[54932.231849] test 6 (128 bit key, 4096 byte blocks):
[54933.231821] 87536 operations in 1 seconds (358547456 bytes)
[54933.231841] test 7 (128 bit key, 8192 byte blocks):
[54934.231783] 46091 operations in 1 seconds (377577472 bytes)
[54934.231803] test 8 (192 bit key, 16 byte blocks):
[54935.231773] 730135 operations in 1 seconds (11682160 bytes)
[54935.231792] test 9 (192 bit key, 64 byte blocks):
[54936.231762] 694952 operations in 1 seconds (44476928 bytes)
[54936.231782] test 10 (192 bit key, 256 byte blocks):
[54937.231754] 479033 operations in 1 seconds (122632448 bytes)
[54937.231774] test 11 (192 bit key, 512 byte blocks):
[54938.231747] 339268 operations in 1 seconds (173705216 bytes)
[54938.231767] test 12 (192 bit key, 1024 byte blocks):
[54939.231744] 216619 operations in 1 seconds (221817856 bytes)
[54939.231763] test 13 (192 bit key, 2048 byte blocks):
[54940.231758] 136358 operations in 1 seconds (279261184 bytes)
[54940.231778] test 14 (192 bit key, 4096 byte blocks):
[54941.231719] 79845 operations in 1 seconds (327045120 bytes)
[54941.231756] test 15 (192 bit key, 8192 byte blocks):
[54942.231740] 42121 operations in 1 seconds (345055232 bytes)
[54942.231761] test 16 (256 bit key, 16 byte blocks):
[54943.231712] 718082 operations in 1 seconds (11489312 bytes)
[54943.231733] test 17 (256 bit key, 64 byte blocks):
[54944.231691] 677413 operations in 1 seconds (43354432 bytes)
[54944.231711] test 18 (256 bit key, 256 byte blocks):
[54945.231683] 463746 operations in 1 seconds (118718976 bytes)
[54945.231703] test 19 (256 bit key, 512 byte blocks):
[54946.231710] 321881 operations in 1 seconds (164803072 bytes)
[54946.231744] test 20 (256 bit key, 1024 byte blocks):
[54947.231667] 224947 operations in 1 seconds (230345728 bytes)
[54947.231687] test 21 (256 bit key, 2048 byte blocks):
[54948.231661] 136130 operations in 1 seconds (278794240 bytes)
[54948.231681] test 22 (256 bit key, 4096 byte blocks):
[54949.231667] 75775 operations in 1 seconds (310374400 bytes)
[54949.231701] test 23 (256 bit key, 8192 byte blocks):
[54950.231677] 39429 operations in 1 seconds (323002368 bytes)


And here is 5.4 with the old patch:

                testing speed of rfc4106(gcm(aes)) (rfc4106-gcm-aesni) encryption
[  189.151375] test 0 (160 bit key, 16 byte blocks):
[  190.150706] 813049 operations in 1 seconds (13008784 bytes)
[  190.150725] test 1 (160 bit key, 64 byte blocks):
[  191.150708] 774554 operations in 1 seconds (49571456 bytes)
[  191.150726] test 2 (160 bit key, 256 byte blocks):
[  192.150714] 532955 operations in 1 seconds (136436480 bytes)
[  192.150732] test 3 (160 bit key, 512 byte blocks):
[  193.150663] 376599 operations in 1 seconds (192818688 bytes)
[  193.150681] test 4 (160 bit key, 1024 byte blocks):
[  194.150655] 262476 operations in 1 seconds (268775424 bytes)
[  194.150703] test 5 (160 bit key, 2048 byte blocks):
[  195.150673] 160616 operations in 1 seconds (328941568 bytes)
[  195.150693] test 6 (160 bit key, 4096 byte blocks):
[  196.150667] 90413 operations in 1 seconds (370331648 bytes)
[  196.150687] test 7 (160 bit key, 8192 byte blocks):
[  197.150658] 47446 operations in 1 seconds (388677632 bytes)
[  197.150783]
                testing speed of gcm(aes) (generic-gcm-aesni) encryption
[  197.150797] test 0 (128 bit key, 16 byte blocks):
[  198.150641] 851015 operations in 1 seconds (13616240 bytes)
[  198.150660] test 1 (128 bit key, 64 byte blocks):
[  199.150629] 815656 operations in 1 seconds (52201984 bytes)
[  199.150648] test 2 (128 bit key, 256 byte blocks):
[  200.150617] 553263 operations in 1 seconds (141635328 bytes)
[  200.150675] test 3 (128 bit key, 512 byte blocks):
[  201.150611] 386949 operations in 1 seconds (198117888 bytes)
[  201.150660] test 4 (128 bit key, 1024 byte blocks):
[  202.150601] 268681 operations in 1 seconds (275129344 bytes)
[  202.150635] test 5 (128 bit key, 2048 byte blocks):
[  203.150588] 162482 operations in 1 seconds (332763136 bytes)
[  203.150607] test 6 (128 bit key, 4096 byte blocks):
[  204.150549] 92852 operations in 1 seconds (380321792 bytes)
[  204.150569] test 7 (128 bit key, 8192 byte blocks):
[  205.150571] 48214 operations in 1 seconds (394969088 bytes)
[  205.150592] test 8 (192 bit key, 16 byte blocks):
[  206.150526] 832863 operations in 1 seconds (13325808 bytes)
[  206.150546] test 9 (192 bit key, 64 byte blocks):
[  207.150545] 784489 operations in 1 seconds (50207296 bytes)
[  207.150566] test 10 (192 bit key, 256 byte blocks):
[  208.150506] 530243 operations in 1 seconds (135742208 bytes)
[  208.150526] test 11 (192 bit key, 512 byte blocks):
[  209.150506] 366099 operations in 1 seconds (187442688 bytes)
[  209.150532] test 12 (192 bit key, 1024 byte blocks):
[  210.150488] 250462 operations in 1 seconds (256473088 bytes)
[  210.150509] test 13 (192 bit key, 2048 byte blocks):
[  211.150486] 151644 operations in 1 seconds (310566912 bytes)
[  211.150507] test 14 (192 bit key, 4096 byte blocks):
[  212.150474] 84226 operations in 1 seconds (344989696 bytes)
[  212.150494] test 15 (192 bit key, 8192 byte blocks):
[  213.150560] 43609 operations in 1 seconds (357244928 bytes)
[  213.150581] test 16 (256 bit key, 16 byte blocks):
[  214.150445] 804817 operations in 1 seconds (12877072 bytes)
[  214.150464] test 17 (256 bit key, 64 byte blocks):
[  215.150447] 764872 operations in 1 seconds (48951808 bytes)
[  215.150467] test 18 (256 bit key, 256 byte blocks):
[  216.150451] 501522 operations in 1 seconds (128389632 bytes)
[  216.150471] test 19 (256 bit key, 512 byte blocks):
[  217.150463] 339614 operations in 1 seconds (173882368 bytes)
[  217.150495] test 20 (256 bit key, 1024 byte blocks):
[  218.150406] 238889 operations in 1 seconds (244622336 bytes)
[  218.150426] test 21 (256 bit key, 2048 byte blocks):
[  219.150406] 141513 operations in 1 seconds (289818624 bytes)
[  219.150426] test 22 (256 bit key, 4096 byte blocks):
[  220.150432] 77995 operations in 1 seconds (319467520 bytes)
[  220.150453] test 23 (256 bit key, 8192 byte blocks):
[  221.150410] 40279 operations in 1 seconds (329965568 bytes)
[  221.150546]
                testing speed of rfc4106(gcm(aes)) (rfc4106-gcm-aesni) decryption
[  221.150561] test 0 (160 bit key, 16 byte blocks):
[  222.150393] 758689 operations in 1 seconds (12139024 bytes)
[  222.150426] test 1 (160 bit key, 64 byte blocks):
[  223.150351] 599877 operations in 1 seconds (38392128 bytes)
[  223.150399] test 2 (160 bit key, 256 byte blocks):
[  224.150339] 453279 operations in 1 seconds (116039424 bytes)
[  224.150360] test 3 (160 bit key, 512 byte blocks):
[  225.150367] 332659 operations in 1 seconds (170321408 bytes)
[  225.150392] test 4 (160 bit key, 1024 byte blocks):
[  226.150375] 258949 operations in 1 seconds (265163776 bytes)
[  226.150394] test 5 (160 bit key, 2048 byte blocks):
[  227.150345] 157536 operations in 1 seconds (322633728 bytes)
[  227.150382] test 6 (160 bit key, 4096 byte blocks):
[  228.150341] 89150 operations in 1 seconds (365158400 bytes)
[  228.150360] test 7 (160 bit key, 8192 byte blocks):
[  229.150291] 46679 operations in 1 seconds (382394368 bytes)
[  229.150420]
                testing speed of gcm(aes) (generic-gcm-aesni) decryption
[  229.150435] test 0 (128 bit key, 16 byte blocks):
[  230.150312] 784010 operations in 1 seconds (12544160 bytes)
[  230.150331] test 1 (128 bit key, 64 byte blocks):
[  231.150271] 616765 operations in 1 seconds (39472960 bytes)
[  231.150290] test 2 (128 bit key, 256 byte blocks):
[  232.150251] 456053 operations in 1 seconds (116749568 bytes)
[  232.150271] test 3 (128 bit key, 512 byte blocks):
[  233.150245] 339125 operations in 1 seconds (173632000 bytes)
[  233.150264] test 4 (128 bit key, 1024 byte blocks):
[  234.150251] 260288 operations in 1 seconds (266534912 bytes)
[  234.150300] test 5 (128 bit key, 2048 byte blocks):
[  235.150225] 158126 operations in 1 seconds (323842048 bytes)
[  235.150245] test 6 (128 bit key, 4096 byte blocks):
[  236.150203] 89756 operations in 1 seconds (367640576 bytes)
[  236.150222] test 7 (128 bit key, 8192 byte blocks):
[  237.150238] 46408 operations in 1 seconds (380174336 bytes)
[  237.150258] test 8 (192 bit key, 16 byte blocks):
[  238.150185] 767710 operations in 1 seconds (12283360 bytes)
[  238.150204] test 9 (192 bit key, 64 byte blocks):
[  239.150223] 602290 operations in 1 seconds (38546560 bytes)
[  239.150243] test 10 (192 bit key, 256 byte blocks):
[  240.150156] 440038 operations in 1 seconds (112649728 bytes)
[  240.150177] test 11 (192 bit key, 512 byte blocks):
[  241.150144] 321800 operations in 1 seconds (164761600 bytes)
[  241.150164] test 12 (192 bit key, 1024 byte blocks):
[  242.150137] 213059 operations in 1 seconds (218172416 bytes)
[  242.150186] test 13 (192 bit key, 2048 byte blocks):
[  243.150119] 134641 operations in 1 seconds (275744768 bytes)
[  243.150138] test 14 (192 bit key, 4096 byte blocks):
[  244.150110] 78540 operations in 1 seconds (321699840 bytes)
[  244.150131] test 15 (192 bit key, 8192 byte blocks):
[  245.150124] 41604 operations in 1 seconds (340819968 bytes)
[  245.150144] test 16 (256 bit key, 16 byte blocks):
[  246.150143] 749367 operations in 1 seconds (11989872 bytes)
[  246.150179] test 17 (256 bit key, 64 byte blocks):
[  247.150101] 584427 operations in 1 seconds (37403328 bytes)
[  247.150121] test 18 (256 bit key, 256 byte blocks):
[  248.150087] 427519 operations in 1 seconds (109444864 bytes)
[  248.150107] test 19 (256 bit key, 512 byte blocks):
[  249.150046] 309171 operations in 1 seconds (158295552 bytes)
[  249.150065] test 20 (256 bit key, 1024 byte blocks):
[  250.150058] 236908 operations in 1 seconds (242593792 bytes)
[  250.150078] test 21 (256 bit key, 2048 byte blocks):
[  251.150027] 139251 operations in 1 seconds (285186048 bytes)
[  251.150048] test 22 (256 bit key, 4096 byte blocks):
[  252.150066] 76453 operations in 1 seconds (313151488 bytes)
[  252.150118] test 23 (256 bit key, 8192 byte blocks):
[  253.150039] 39852 operations in 1 seconds (326467584 bytes)


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
