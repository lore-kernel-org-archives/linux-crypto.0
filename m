From: Tudor Ambarus <tudor.ambarus-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
Subject: Re: [RESEND RFC PATCH 1/2] Bluetooth: move ecdh allocation outside of
 ecdh_helper
Date: Mon, 25 Sep 2017 19:11:12 +0300
Message-ID: <9f64b6c7-6171-6d01-ed7e-64b9009d193d@microchip.com>
References: <20170925102356.4427-1-tudor.ambarus@microchip.com>
 <20170925102356.4427-2-tudor.ambarus@microchip.com>
 <F95FB3E8-B1A5-4EB5-ABB5-50C8BD16D51C@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-bluetooth-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>
Return-path: <linux-bluetooth-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <F95FB3E8-B1A5-4EB5-ABB5-50C8BD16D51C-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>
Content-Language: en-US
Sender: linux-bluetooth-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi, Marcel,

On 09/25/2017 04:02 PM, Marcel Holtmann wrote:

>> diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
>> index a0ef897..6532689 100644
>> --- a/net/bluetooth/smp.c
>> +++ b/net/bluetooth/smp.c

[cut]

>> @@ -2677,7 +2695,16 @@ static int smp_cmd_public_key(struct l2cap_conn *conn, struct sk_buff *skb)
>> 	SMP_DBG("Remote Public Key X: %32phN", smp->remote_pk);
>> 	SMP_DBG("Remote Public Key Y: %32phN", smp->remote_pk + 32);
>>
>> -	if (!compute_ecdh_secret(smp->remote_pk, smp->local_sk, smp->dhkey))
>> +	if (test_bit(SMP_FLAG_LOCAL_OOB, &smp->flags)) {
>> +		struct smp_dev *smp_dev = chan->data;
>> +
>> +		tfm = smp_dev->tfm_ecdh;
>> +	} else {
>> +		tfm = smp->tfm_ecdh;
>> +	}
> 
> this looks all good, but I do not understand the need of this extra if clause here. Can you explain why OOB case is different or maybe add some comment in the code to make this clear.

This particular change should have been in patch 2/2.
It's needed because I need to compute the shared secret on the
same tfm on which the private key was set/generated.

Thanks,
ta
